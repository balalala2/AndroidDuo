import com.android.apksig.*;import java.io.*;import java.security.*;import java.security.cert.X509Certificate;import java.util.*;
public class Sign{public static void main(String[] a)throws Exception{
  KeyStore ks=KeyStore.getInstance("PKCS12");ks.load(new FileInputStream(a[2]),"zsplit123".toCharArray());
  PrivateKey k=(PrivateKey)ks.getKey("zsplit","zsplit123".toCharArray());X509Certificate c=(X509Certificate)ks.getCertificate("zsplit");
  ApkSigner.SignerConfig sc=new ApkSigner.SignerConfig.Builder("zsplit",k,Collections.singletonList(c)).build();
  new ApkSigner.Builder(Collections.singletonList(sc)).setInputApk(new File(a[0])).setOutputApk(new File(a[1])).setMinSdkVersion(29).setV1SigningEnabled(false).setV2SigningEnabled(true).setV3SigningEnabled(true).build().sign();
  ApkVerifier.Result r=new ApkVerifier.Builder(new File(a[1])).build().verify();System.out.println("verified="+r.isVerified()+" v2="+r.isVerifiedUsingV2Scheme()+" v3="+r.isVerifiedUsingV3Scheme());
  X509Certificate rc=r.getSignerCertificates().get(0);System.out.println("cert sha256="+String.format("%064x",new java.math.BigInteger(1,MessageDigest.getInstance("SHA-256").digest(rc.getEncoded()))));}}
