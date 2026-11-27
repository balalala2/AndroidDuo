import com.android.apksig.ApkVerifier;
import java.io.File;
import java.security.MessageDigest;
import java.security.cert.X509Certificate;
import java.util.List;

public class VerifyCert {
    public static void main(String[] args) throws Exception {
        if (args.length < 1) {
            System.err.println("Usage: VerifyCert <apk>");
            System.exit(2);
        }
        File apk = new File(args[0]);
        ApkVerifier.Result res = new ApkVerifier.Builder(apk).build().verify();
        if (!res.isVerified()) {
            for (ApkVerifier.IssueWithParams err : res.getAllErrors()) {
                System.err.println("ERROR: " + err);
            }
            System.exit(1);
        }
        List<X509Certificate> certs = res.getSignerCertificates();
        if (certs.isEmpty()) {
            System.err.println("ERROR: No signer certificates found");
            System.exit(1);
        }
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] digest = md.digest(certs.get(0).getEncoded());
        StringBuilder sb = new StringBuilder();
        for (byte b : digest) {
            sb.append(String.format("%02x", b & 0xff));
        }
        System.out.println("VERIFIED=true");
        System.out.println("V1=" + res.isVerifiedUsingV1Scheme()
            + " V2=" + res.isVerifiedUsingV2Scheme()
            + " V3=" + res.isVerifiedUsingV3Scheme());
        System.out.println("CERT_SHA256=" + sb.toString());
    }
}
