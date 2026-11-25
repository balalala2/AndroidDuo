import com.android.tools.smali.smali.*;import java.util.*;
public class Asm { public static void main(String[] a) throws Exception { SmaliOptions o = new SmaliOptions(); o.apiLevel = 29; o.outputDexFile = a[0]; o.verboseErrors = true;
 boolean ok = Smali.assemble(o, Arrays.asList(a).subList(1, a.length)); System.out.println("ok=" + ok); } }
