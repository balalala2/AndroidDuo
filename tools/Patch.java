import com.android.tools.smali.dexlib2.*;import com.android.tools.smali.dexlib2.iface.*;import com.android.tools.smali.dexlib2.iface.instruction.*;import com.android.tools.smali.dexlib2.iface.reference.*;
import com.android.tools.smali.dexlib2.immutable.*;import com.android.tools.smali.dexlib2.immutable.instruction.*;import com.android.tools.smali.dexlib2.builder.*;import com.android.tools.smali.dexlib2.builder.instruction.*;
import com.android.tools.smali.dexlib2.writer.pool.DexPool;import com.android.tools.smali.dexlib2.writer.io.FileDataStore;import java.io.*;import java.util.*;
// args: in out type method mode  (mode: false = return false ; norecreate = nop out Activity.recreate calls)
public class Patch{public static void main(String[] a)throws Exception{
 DexFile d=DexFileFactory.loadDexFile(new File(a[0]),Opcodes.forApi(29));DexPool pool=new DexPool(Opcodes.forApi(29));int hits=0;
 for(ClassDef c:d.getClasses()){ if(!c.getType().equals(a[2])){pool.internClass(c);continue;}
  List<Method> ms=new ArrayList<>();
  for(Method m:c.getMethods()){ if(!m.getName().equals(a[3])||m.getImplementation()==null){ms.add(m);continue;}
   MethodImplementation impl=m.getImplementation(); MethodImplementation ni;
   if(a[4].equals("false")){ ni=new ImmutableMethodImplementation(impl.getRegisterCount(),Arrays.asList(new ImmutableInstruction11n(Opcode.CONST_4,0,0),new ImmutableInstruction11x(Opcode.RETURN,0)),null,null); hits++; }
   else { MutableMethodImplementation mi=new MutableMethodImplementation(impl); List<BuilderInstruction> ins=mi.getInstructions();
     for(int i=0;i<ins.size();i++){Instruction x=ins.get(i); if(x instanceof ReferenceInstruction){Reference r=((ReferenceInstruction)x).getReference();
       if(r instanceof MethodReference && ((MethodReference)r).getName().equals("recreate") && ((MethodReference)r).getDefiningClass().equals("Landroid/app/Activity;")){mi.replaceInstruction(i,new BuilderInstruction10x(Opcode.NOP));hits++;}}}
     ni=mi; }
   ms.add(new ImmutableMethod(m.getDefiningClass(),m.getName(),m.getParameters(),m.getReturnType(),m.getAccessFlags(),m.getAnnotations(),m.getHiddenApiRestrictions(),ni)); }
  pool.internClass(new ImmutableClassDef(c.getType(),c.getAccessFlags(),c.getSuperclass(),c.getInterfaces(),c.getSourceFile(),c.getAnnotations(),c.getFields(),ms)); }
 pool.writeTo(new FileDataStore(new File(a[1]))); System.out.println("hits="+hits);}}
