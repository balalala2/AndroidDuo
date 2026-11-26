import com.android.tools.smali.dexlib2.*;
import com.android.tools.smali.dexlib2.iface.*;
import com.android.tools.smali.dexlib2.iface.instruction.*;
import com.android.tools.smali.dexlib2.iface.instruction.formats.*;
import com.android.tools.smali.dexlib2.iface.reference.*;
import com.android.tools.smali.dexlib2.immutable.*;
import com.android.tools.smali.dexlib2.immutable.instruction.*;
import com.android.tools.smali.dexlib2.builder.*;
import com.android.tools.smali.dexlib2.builder.instruction.*;
import com.android.tools.smali.dexlib2.writer.pool.DexPool;
import com.android.tools.smali.dexlib2.writer.io.FileDataStore;
import java.io.*;
import java.util.*;

public class RebuildDex {
    public static void main(String[] a) throws Exception {
        Opcodes op = Opcodes.forApi(29);
        if (a[0].equals("replace")) {
            // replace base.dex patch.dex out.dex
            DexFile base = DexFileFactory.loadDexFile(new File(a[1]), op);
            DexFile patch = DexFileFactory.loadDexFile(new File(a[2]), op);
            Set<String> repl = new HashSet<>();
            DexPool pool = new DexPool(op);
            for (ClassDef c : patch.getClasses()) {
                repl.add(c.getType());
                pool.internClass(c);
                System.out.println("patched class: " + c.getType());
            }
            int kept = 0;
            for (ClassDef c : base.getClasses()) {
                if (!repl.contains(c.getType())) {
                    pool.internClass(c);
                    kept++;
                }
            }
            pool.writeTo(new FileDataStore(new File(a[3])));
            System.out.println("replace ok: patched=" + repl.size() + " kept=" + kept);
        } else if (a[0].equals("killzv")) {
            // killzv classes5.orig.dex classes5.patched.dex
            DexFile base = DexFileFactory.loadDexFile(new File(a[1]), op);
            DexPool pool = new DexPool(op);
            Set<String> falseMethods = new HashSet<>(Arrays.asList("a", "b", "f", "h"));
            int hits = 0;
            for (ClassDef c : base.getClasses()) {
                if (!c.getType().equals("Lovu;")) {
                    pool.internClass(c);
                    continue;
                }
                List<Method> ms = new ArrayList<>();
                for (Method m : c.getMethods()) {
                    if (falseMethods.contains(m.getName()) && m.getReturnType().equals("Z") && m.getParameterTypes().isEmpty() && m.getImplementation() != null) {
                        MethodImplementation ni = new ImmutableMethodImplementation(
                            Math.max(1, m.getImplementation().getRegisterCount()),
                            Arrays.asList(
                                new ImmutableInstruction11n(Opcode.CONST_4, 0, 0),
                                new ImmutableInstruction11x(Opcode.RETURN, 0)
                            ),
                            null, null
                        );
                        ms.add(new ImmutableMethod(
                            m.getDefiningClass(), m.getName(), m.getParameters(),
                            m.getReturnType(), m.getAccessFlags(), m.getAnnotations(),
                            m.getHiddenApiRestrictions(), ni
                        ));
                        System.out.println("Lovu->" + m.getName() + "()Z -> return false");
                        hits++;
                    } else if (m.getName().equals("d") && m.getReturnType().equals("Ljava/lang/String;") && m.getParameterTypes().isEmpty() && m.getImplementation() != null) {
                        MethodImplementation ni = new ImmutableMethodImplementation(
                            Math.max(1, m.getImplementation().getRegisterCount()),
                            Arrays.asList(
                                new ImmutableInstruction11n(Opcode.CONST_4, 0, 0),
                                new ImmutableInstruction11x(Opcode.RETURN_OBJECT, 0)
                            ),
                            null, null
                        );
                        ms.add(new ImmutableMethod(
                            m.getDefiningClass(), m.getName(), m.getParameters(),
                            m.getReturnType(), m.getAccessFlags(), m.getAnnotations(),
                            m.getHiddenApiRestrictions(), ni
                        ));
                        System.out.println("Lovu->d()String -> return null");
                        hits++;
                    } else {
                        ms.add(m);
                    }
                }
                pool.internClass(new ImmutableClassDef(
                    c.getType(), c.getAccessFlags(), c.getSuperclass(),
                    c.getInterfaces(), c.getSourceFile(), c.getAnnotations(),
                    c.getFields(), ms
                ));
            }
            pool.writeTo(new FileDataStore(new File(a[2])));
            System.out.println("killzv ok: hits=" + hits);
        } else if (a[0].equals("fixcontact")) {
            // fixcontact classes4.dex classes4.patched.dex
            DexFile base = DexFileFactory.loadDexFile(new File(a[1]), op);
            DexPool pool = new DexPool(op);
            int hits = 0;
            for (ClassDef c : base.getClasses()) {
                if (!c.getType().equals("Lcom/zing/zalo/zalocontact/ui/zaloview/ContactTabZaloView;")) {
                    pool.internClass(c);
                    continue;
                }
                List<Method> ms = new ArrayList<>();
                for (Method m : c.getMethods()) {
                    if (m.getName().equals("Y6") && m.getReturnType().equals("Z") && m.getParameterTypes().isEmpty() && m.getImplementation() != null) {
                        MutableMethodImplementation mi = new MutableMethodImplementation(m.getImplementation());
                        List<BuilderInstruction> ins = mi.getInstructions();
                        for (int i = 0; i < ins.size(); i++) {
                            Instruction x = ins.get(i);
                            if (x.getOpcode() == Opcode.INSTANCE_OF && x instanceof ReferenceInstruction && x instanceof TwoRegisterInstruction) {
                                Reference r = ((ReferenceInstruction) x).getReference();
                                if (r.toString().equals("Lcom/zing/zalo/ui/maintab/MainTabView;")) {
                                    int regA = ((TwoRegisterInstruction) x).getRegisterA();
                                    mi.replaceInstruction(i, new BuilderInstruction11n(Opcode.CONST_4, regA, 1));
                                    System.out.println("ContactTabZaloView->Y6()Z: replaced instance-of MainTabView at idx=" + i + " reg=" + regA + " with const/4 1");
                                    hits++;
                                }
                            }
                        }
                        ms.add(new ImmutableMethod(
                            m.getDefiningClass(), m.getName(), m.getParameters(),
                            m.getReturnType(), m.getAccessFlags(), m.getAnnotations(),
                            m.getHiddenApiRestrictions(), mi
                        ));
                    } else {
                        ms.add(m);
                    }
                }
                pool.internClass(new ImmutableClassDef(
                    c.getType(), c.getAccessFlags(), c.getSuperclass(),
                    c.getInterfaces(), c.getSourceFile(), c.getAnnotations(),
                    c.getFields(), ms
                ));
            }
            pool.writeTo(new FileDataStore(new File(a[2])));
            System.out.println("fixcontact ok: hits=" + hits);
        } else if (a[0].equals("hookn0")) {
            // hookn0 classes.dex classes.patched.dex
            DexFile base = DexFileFactory.loadDexFile(new File(a[1]), op);
            DexPool pool = new DexPool(op);
            int hits = 0;
            for (ClassDef c : base.getClasses()) {
                if (!c.getType().equals("Lcom/zing/zalo/zview/b;")) {
                    pool.internClass(c);
                    continue;
                }
                List<Method> ms = new ArrayList<>();
                for (Method m : c.getMethods()) {
                    if (m.getName().equals("n0")
                            && m.getParameterTypes().equals(Arrays.asList("Llio;", "I"))
                            && m.getReturnType().equals("V")
                            && m.getImplementation() != null) {
                        MethodImplementation impl = m.getImplementation();
                        MutableMethodImplementation mi = new MutableMethodImplementation(impl);
                        int totalRegs = impl.getRegisterCount();
                        int p0 = totalRegs - 3; // this, Llio, I
                        com.android.tools.smali.dexlib2.immutable.reference.ImmutableMethodReference mref =
                            new com.android.tools.smali.dexlib2.immutable.reference.ImmutableMethodReference(
                                "Lcom/zing/zalo/zsplit/ZSplit;",
                                "keepMainState",
                                Arrays.asList("Lcom/zing/zalo/zview/b;", "Llio;", "I"),
                                "Z"
                            );
                        Label cont = mi.newLabelForIndex(0);
                        mi.addInstruction(0, new BuilderInstruction3rc(Opcode.INVOKE_STATIC_RANGE, p0, 3, mref));
                        mi.addInstruction(1, new BuilderInstruction11x(Opcode.MOVE_RESULT, 0));
                        mi.addInstruction(2, new BuilderInstruction21t(Opcode.IF_EQZ, 0, cont));
                        mi.addInstruction(3, new BuilderInstruction10x(Opcode.RETURN_VOID));
                        ms.add(new ImmutableMethod(
                            m.getDefiningClass(), m.getName(), m.getParameters(),
                            m.getReturnType(), m.getAccessFlags(), m.getAnnotations(),
                            m.getHiddenApiRestrictions(), mi
                        ));
                        System.out.println("zview.b->n0(Llio;I)V hooked with keepMainState! totalRegs=" + totalRegs + " p0=" + p0);
                        hits++;
                    } else {
                        ms.add(m);
                    }
                }
                pool.internClass(new ImmutableClassDef(
                    c.getType(), c.getAccessFlags(), c.getSuperclass(),
                    c.getInterfaces(), c.getSourceFile(), c.getAnnotations(),
                    c.getFields(), ms
                ));
            }
            pool.writeTo(new FileDataStore(new File(a[2])));
            System.out.println("hookn0 ok: hits=" + hits);
        }
    }
}
