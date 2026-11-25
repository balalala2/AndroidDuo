import com.android.tools.smali.dexlib2.*;import com.android.tools.smali.dexlib2.iface.*;import com.android.tools.smali.dexlib2.analysis.*;import java.io.*;import java.util.*;
public class Verify{public static void main(String[] a)throws Exception{
 List<ClassProvider> cps=new ArrayList<>();
 for(String f:a){cps.add(new DexClassProvider(DexFileFactory.loadDexFile(f,Opcodes.forApi(29))));}
 ClassPath cp=new ClassPath(cps,false,0);
 DexFile d=DexFileFactory.loadDexFile(a[0],Opcodes.forApi(29));
 for(ClassDef c:d.getClasses()){ if(!c.getType().contains("zsplit"))continue;
  for(Method m:c.getMethods()){ if(m.getImplementation()==null)continue;
   try{MethodAnalyzer ma=new MethodAnalyzer(cp,m,null,false);
    AnalysisException e=ma.getAnalysisException(); if(e!=null)System.out.println(c.getType()+"->"+m.getName()+": "+e.getMessage()+" @"+e.codeAddress);
   }catch(Throwable t){System.out.println(c.getType()+"->"+m.getName()+" EXC "+t);}
 }}
 System.out.println("done");}}
