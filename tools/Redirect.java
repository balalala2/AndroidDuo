import com.android.tools.smali.dexlib2.*;import com.android.tools.smali.dexlib2.iface.*;import com.android.tools.smali.dexlib2.iface.instruction.*;import com.android.tools.smali.dexlib2.iface.instruction.formats.*;import com.android.tools.smali.dexlib2.iface.reference.*;
import com.android.tools.smali.dexlib2.immutable.*;import com.android.tools.smali.dexlib2.immutable.reference.*;import com.android.tools.smali.dexlib2.builder.*;import com.android.tools.smali.dexlib2.builder.instruction.*;
import com.android.tools.smali.dexlib2.writer.pool.DexPool;import com.android.tools.smali.dexlib2.writer.io.FileDataStore;import java.io.*;import java.util.*;
// in out type helperClass : redirect ViewGroup.removeView/addView invoke-virtual to static helper with same name prefix "zs_"
public class Redirect{public static void main(String[] a)throws Exception{
 DexFile d=DexFileFactory.loadDexFile(new File(a[0]),Opcodes.forApi(29));DexPool pool=new DexPool(Opcodes.forApi(29));int hits=0;
 for(ClassDef c:d.getClasses()){ if(!c.getType().equals(a[2])){pool.internClass(c);continue;}
  List<Method> ms=new ArrayList<>();
  for(Method m:c.getMethods()){ if(m.getImplementation()==null){ms.add(m);continue;}
   MutableMethodImplementation mi=new MutableMethodImplementation(m.getImplementation());List<BuilderInstruction> ins=mi.getInstructions();boolean ch=false;
   for(int i=0;i<ins.size();i++){Instruction x=ins.get(i);if(x.getOpcode()!=Opcode.INVOKE_VIRTUAL)continue;MethodReference r=(MethodReference)((ReferenceInstruction)x).getReference();
    if(!r.getDefiningClass().equals("Landroid/view/ViewGroup;"))continue;String n=r.getName();if(!n.equals("removeView")&&!n.equals("addView"))continue;
    List<String> ps=new ArrayList<>();ps.add("Landroid/view/ViewGroup;");for(CharSequence p:r.getParameterTypes())ps.add(p.toString());
    ImmutableMethodReference nr=new ImmutableMethodReference(a[3],"zs_"+n,ps,"V");Instruction35c f=(Instruction35c)x;
    mi.replaceInstruction(i,new BuilderInstruction35c(Opcode.INVOKE_STATIC,f.getRegisterCount(),f.getRegisterC(),f.getRegisterD(),f.getRegisterE(),f.getRegisterF(),f.getRegisterG(),nr));hits++;ch=true;}
   ms.add(ch?new ImmutableMethod(m.getDefiningClass(),m.getName(),m.getParameters(),m.getReturnType(),m.getAccessFlags(),m.getAnnotations(),m.getHiddenApiRestrictions(),mi):m);}
  pool.internClass(new ImmutableClassDef(c.getType(),c.getAccessFlags(),c.getSuperclass(),c.getInterfaces(),c.getSourceFile(),c.getAnnotations(),c.getFields(),ms));}
 pool.writeTo(new FileDataStore(new File(a[1])));System.out.println("hits="+hits);}}
