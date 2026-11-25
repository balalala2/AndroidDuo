import com.android.tools.smali.dexlib2.*;import com.android.tools.smali.dexlib2.iface.*;import com.android.tools.smali.dexlib2.immutable.*;import com.android.tools.smali.dexlib2.immutable.reference.*;
import com.android.tools.smali.dexlib2.builder.*;import com.android.tools.smali.dexlib2.builder.instruction.*;import com.android.tools.smali.dexlib2.writer.pool.DexPool;import com.android.tools.smali.dexlib2.writer.io.FileDataStore;import java.io.*;import java.util.*;
// args: in out type comma-methods staticClass staticName  -> inserts invoke-static {p0}, staticClass->staticName(type)V at method start
public class Prefix{public static void main(String[] a)throws Exception{
 DexFile d=DexFileFactory.loadDexFile(new File(a[0]),Opcodes.forApi(29));DexPool pool=new DexPool(Opcodes.forApi(29));int hits=0;Set<String> names=new HashSet<>(Arrays.asList(a[3].split(",")));
 ImmutableMethodReference ref=new ImmutableMethodReference(a[4],a[5],Collections.singletonList(a[2]),"V");
 for(ClassDef c:d.getClasses()){ if(!c.getType().equals(a[2])){pool.internClass(c);continue;}
  List<Method> ms=new ArrayList<>();
  for(Method m:c.getMethods()){ if(!names.contains(m.getName())||m.getImplementation()==null||AccessFlags.STATIC.isSet(m.getAccessFlags())){ms.add(m);continue;}
   MutableMethodImplementation mi=new MutableMethodImplementation(m.getImplementation());
   int preg=1;for(CharSequence p:m.getParameterTypes()){String s=p.toString();preg+=(s.equals("J")||s.equals("D"))?2:1;}
   int p0=mi.getRegisterCount()-preg;
   mi.addInstruction(0,new BuilderInstruction35c(Opcode.INVOKE_STATIC,1,p0,0,0,0,0,ref));hits++;
   ms.add(new ImmutableMethod(m.getDefiningClass(),m.getName(),m.getParameters(),m.getReturnType(),m.getAccessFlags(),m.getAnnotations(),m.getHiddenApiRestrictions(),mi)); }
  pool.internClass(new ImmutableClassDef(c.getType(),c.getAccessFlags(),c.getSuperclass(),c.getInterfaces(),c.getSourceFile(),c.getAnnotations(),c.getFields(),ms)); }
 pool.writeTo(new FileDataStore(new File(a[1]))); System.out.println("hits="+hits);}}
