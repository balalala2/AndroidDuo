import com.reandroid.dex.model.*;import com.reandroid.dex.smali.*;import java.io.*;import java.util.*;
public class Dump{public static void main(String[] a)throws Exception{DexFile d=DexFile.read(new FileInputStream(a[0]),null);
StringWriter sw=new StringWriter();SmaliWriter w=new SmaliWriter(sw);
for(DexLayout l:d){Iterator<DexClass> it=l.iterator();while(it.hasNext()){DexClass c=it.next();if(a.length>2&&!c.getKey().toString().contains(a[2]))continue;c.append(w);w.newLine();}}
w.close();try(FileWriter f=new FileWriter(a[1])){f.write(sw.toString());}}}
