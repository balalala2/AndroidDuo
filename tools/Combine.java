import com.android.tools.smali.dexlib2.*;import com.android.tools.smali.dexlib2.iface.*;import com.android.tools.smali.dexlib2.writer.pool.DexPool;import com.android.tools.smali.dexlib2.writer.io.FileDataStore;import java.io.*;
public class Combine{public static void main(String[] a)throws Exception{DexPool p=new DexPool(Opcodes.forApi(29));
for(int i=1;i<a.length;i++)for(ClassDef c:DexFileFactory.loadDexFile(new File(a[i]),Opcodes.forApi(29)).getClasses())p.internClass(c);
p.writeTo(new FileDataStore(new File(a[0])));System.out.println("ok");}}
