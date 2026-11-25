import com.android.apksig.*;import java.io.*;import java.security.*;
public class Ver{public static void main(String[] a)throws Exception{ApkVerifier.Result r=new ApkVerifier.Builder(new File(a[0])).build().verify();
System.out.println("ok="+r.isVerified()+" sha256="+String.format("%064x",new java.math.BigInteger(1,MessageDigest.getInstance("SHA-256").digest(r.getSignerCertificates().get(0).getEncoded()))));}}
