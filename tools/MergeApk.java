import com.reandroid.apk.*;import com.reandroid.arsc.chunk.xml.*;import java.io.*;
public class MergeApk{public static void main(String[] a)throws Exception{ApkBundle b=new ApkBundle();b.loadApkDirectory(new File(a[0]),false);
ApkModule m=b.mergeModules(false);
m.setExtractNativeLibs(true);
m.refreshTable();m.refreshManifest();
com.reandroid.archive.writer.ApkFileWriter w=m.createApkFileWriter(new File(a[1]));w.write();w.close();System.out.println("merged");}}
