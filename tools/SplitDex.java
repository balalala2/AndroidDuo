import com.reandroid.dex.model.*;
import com.reandroid.dex.smali.*;
import java.io.*;
import java.util.*;

public class SplitDex {
    public static void main(String[] a) throws Exception {
        if (a.length < 2) {
            System.err.println("Usage: SplitDex <in.dex> <out_dir>");
            System.exit(1);
        }
        File inDex = new File(a[0]);
        File outDir = new File(a[1]);
        outDir.mkdirs();
        DexFile d = DexFile.read(new FileInputStream(inDex), null);
        int count = 0;
        for (DexLayout l : d) {
            Iterator<DexClass> it = l.iterator();
            while (it.hasNext()) {
                DexClass c = it.next();
                String k = c.getKey().toString();
                String name = k.substring(1, k.length() - 1).replace('/', '_') + ".smali";
                File out = new File(outDir, name);
                try (Writer fw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(out), "UTF-8"))) {
                    SmaliWriter w = new SmaliWriter(fw);
                    c.append(w);
                    w.close();
                }
                count++;
            }
        }
        System.out.println("Split " + count + " classes into " + outDir.getPath());
    }
}
