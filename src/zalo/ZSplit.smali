.class public final Lcom/zing/zalo/zsplit/ZSplit;
.super Ljava/lang/Object;

# interfaces
.implements Landroid/view/ViewTreeObserver$OnPreDrawListener;


# static fields
.field static sActP:Z

.field static sBlur:Ljava/util/WeakHashMap;

.field static sClr:I

.field static sContainer:Ljava/lang/ref/WeakReference;

.field static sDefCls:Ljava/lang/Class;

.field static sDiagN:I

.field static sDock:Ljava/util/WeakHashMap;

.field static sDuoLast:Ljava/lang/String;

.field static sFeedHad:Z

.field static sFeedSup:Z

.field static sFeedV:Ljava/lang/ref/WeakReference;

.field static sHadPane:Z

.field static sIsList:Ljava/util/HashMap;

.field static final sKeepVLO:Ljava/util/WeakHashMap;

.field static sLast:Ljava/lang/String;

.field static sLastTab:I

.field static sLastWant:Ljava/lang/Class;

.field static sLastWide:Z

.field static sLay:Ljava/util/WeakHashMap;

.field static sLost:Z

.field static sMainV:Ljava/lang/ref/WeakReference;

.field static sMainW:I

.field static final sMod:Ljava/util/WeakHashMap;

.field static sNeedPop:Z

.field static sNotifHad:Z

.field static sNotifOurs:Z

.field static sNotifSup:Z

.field static sNotifV:Ljava/lang/ref/WeakReference;

.field static sPadT:I

.field static sPendTab:I

.field static sPopT:J

.field static sPushN:I

.field static sPushT:J

.field static sScrim:Ljava/util/WeakHashMap;

.field static final sSeen:Ljava/util/HashSet;

.field static sSup:Z

.field static sTLWas:Z

.field static sTapPend:Z

.field static sTopT:J

.field static sZVn:I


# instance fields
.field final container:Landroid/view/View;

.field final mgr:Lcom/zing/zalo/zview/b;

.field ph:Landroid/view/View;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sMod:Ljava/util/WeakHashMap;

    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    sput-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sSeen:Ljava/util/HashSet;

    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sKeepVLO:Ljava/util/WeakHashMap;

    const/4 v0, -0x1

    sput v0, Lcom/zing/zalo/zsplit/ZSplit;->sLastTab:I

    sput v0, Lcom/zing/zalo/zsplit/ZSplit;->sPendTab:I

    return-void
.end method

.method constructor <init>(Lcom/zing/zalo/zview/b;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/zing/zalo/zsplit/ZSplit;->mgr:Lcom/zing/zalo/zview/b;

    iput-object p2, p0, Lcom/zing/zalo/zsplit/ZSplit;->container:Landroid/view/View;

    return-void
.end method

.method static anyContext(Ljava/util/ArrayList;)Landroid/content/Context;
    .locals 4

    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result v0

    const/4 v1, 0x0

    :goto_5
    if-ge v1, v0, :cond_1d

    invoke-virtual {p0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Llio;

    iget-object v2, v2, Llio;->b:Lu1w;

    if-eqz v2, :cond_1a

    iget-object v2, v2, Lu1w;->x:Landroid/view/View;

    if-eqz v2, :cond_1a

    invoke-virtual {v2}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v2

    return-object v2

    :cond_1a
    add-int/lit8 v1, v1, 0x1

    goto :goto_5

    :cond_1d
    const/4 v2, 0x0

    return-object v2
.end method

.method static apply(Landroid/view/View;II)V
    .locals 2

    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    instance-of v1, v0, Landroid/view/ViewGroup$MarginLayoutParams;

    if-eqz v1, :cond_19

    check-cast v0, Landroid/view/ViewGroup$MarginLayoutParams;

    iget v1, v0, Landroid/view/ViewGroup$LayoutParams;->width:I

    if-ne v1, p1, :cond_12

    iget v1, v0, Landroid/view/ViewGroup$MarginLayoutParams;->leftMargin:I

    if-eq v1, p2, :cond_19

    :cond_12
    iput p1, v0, Landroid/view/ViewGroup$LayoutParams;->width:I

    iput p2, v0, Landroid/view/ViewGroup$MarginLayoutParams;->leftMargin:I

    invoke-virtual {p0, v0}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :cond_19
    return-void
.end method

.method static backdrop(Ljava/util/ArrayList;ILandroid/view/View;)V
    .locals 9

    :try_start_0
    const/4 v0, 0x0

    invoke-static {v0}, Lcom/zing/zalo/zsplit/ZSplit;->map(I)Ljava/util/WeakHashMap;

    move-result-object v1

    const/4 v0, 0x1

    invoke-static {v0}, Lcom/zing/zalo/zsplit/ZSplit;->map(I)Ljava/util/WeakHashMap;

    move-result-object v2

    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result v3

    const/4 v4, 0x0

    if-lez v3, :cond_2e

    add-int/lit8 v5, v3, -0x1

    invoke-virtual {p0, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Llio;

    iget-object v6, v6, Llio;->b:Lu1w;

    if-eqz v6, :cond_2e

    iget-object v6, v6, Lu1w;->x:Landroid/view/View;

    if-eqz v6, :cond_2e

    invoke-virtual {v1, v6}, Ljava/util/WeakHashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_2e

    invoke-virtual {v6}, Landroid/view/View;->getVisibility()I

    move-result v7

    if-nez v7, :cond_2e

    const/4 v4, 0x1

    :cond_2e
    const/4 v5, 0x0

    :goto_2f
    if-ge v5, v3, :cond_7d

    invoke-virtual {p0, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Llio;

    iget-object v7, v6, Llio;->a:Ljava/lang/Class;

    iget-object v6, v6, Llio;->b:Lu1w;

    if-eqz v6, :cond_7a

    iget-object v6, v6, Lu1w;->x:Landroid/view/View;

    if-eqz v6, :cond_7a

    const/4 v8, 0x0

    if-eqz v4, :cond_51

    invoke-virtual {v1, v6}, Ljava/util/WeakHashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_51

    if-eq v5, p1, :cond_50

    const-class v0, Lcom/zing/zalo/ui/chat/ChatView;

    if-ne v7, v0, :cond_51

    :cond_50
    const/4 v8, 0x1

    :cond_51
    if-eqz v8, :cond_6d

    invoke-virtual {v2, v6}, Ljava/util/WeakHashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_7a

    sget-object v0, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v2, v6, v0}, Ljava/util/WeakHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v0, Landroid/graphics/drawable/ColorDrawable;

    const v7, 0x33000000

    invoke-direct {v0, v7}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V

    invoke-virtual {v6, v0}, Landroid/view/View;->setForeground(Landroid/graphics/drawable/Drawable;)V

    invoke-static {v6}, Lcom/zing/zalo/zsplit/ZSplit;->blur(Landroid/view/View;)V

    goto :goto_7a

    :cond_6d
    invoke-virtual {v2, v6}, Ljava/util/WeakHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_7a

    const/4 v0, 0x0

    invoke-virtual {v6, v0}, Landroid/view/View;->setForeground(Landroid/graphics/drawable/Drawable;)V

    invoke-static {v6}, Lcom/zing/zalo/zsplit/ZSplit;->unblur(Landroid/view/View;)V

    :cond_7a
    :goto_7a
    add-int/lit8 v5, v5, 0x1

    goto :goto_2f

    :cond_7d
    invoke-static {p2, v4}, Lcom/zing/zalo/zsplit/ZSplit;->scrim(Landroid/view/View;Z)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_80

    :catch_80
    return-void
.end method

.method static blur(Landroid/view/View;)V
    .locals 3

    :try_start_0
    const/high16 v0, 0x42200000

    sget-object v1, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    invoke-static {v0, v0, v1}, Landroid/graphics/RenderEffect;->createBlurEffect(FFLandroid/graphics/Shader$TileMode;)Landroid/graphics/RenderEffect;

    move-result-object v2

    invoke-virtual {p0, v2}, Landroid/view/View;->setRenderEffect(Landroid/graphics/RenderEffect;)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_b

    :catch_b
    return-void
.end method

.method static canPop()Z
    .locals 6

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    sget-wide v2, Lcom/zing/zalo/zsplit/ZSplit;->sPopT:J

    sub-long v2, v0, v2

    const-wide/16 v4, 0x15e

    cmp-long v2, v2, v4

    if-gez v2, :cond_10

    const/4 v0, 0x0

    return v0

    :cond_10
    sput-wide v0, Lcom/zing/zalo/zsplit/ZSplit;->sPopT:J

    const/4 v0, 0x1

    return v0
.end method

.method static canPush()Z
    .locals 6

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    sget-wide v2, Lcom/zing/zalo/zsplit/ZSplit;->sPushT:J

    sub-long v2, v0, v2

    const-wide/16 v4, 0x320

    cmp-long v2, v2, v4

    if-gez v2, :cond_10

    const/4 v0, 0x0

    return v0

    :cond_10
    sput-wide v0, Lcom/zing/zalo/zsplit/ZSplit;->sPushT:J

    const/4 v0, 0x1

    return v0
.end method

.method static clearKids(Landroid/view/View;)V
    .locals 4

    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_18

    check-cast p0, Landroid/view/ViewGroup;

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v0

    const/4 v1, 0x0

    :goto_b
    if-ge v1, v0, :cond_18

    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    add-int/lit8 v1, v1, 0x1

    goto :goto_b

    :cond_18
    return-void
.end method

.method static clickFirst(Landroid/view/View;)Z
    .locals 15

    :try_start_0
    const-string v0, "chatlinelist"

    invoke-static {p0, v0}, Lcom/zing/zalo/zsplit/ZSplit;->idOf(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object v0

    instance-of v1, v0, Landroid/view/ViewGroup;

    if-eqz v1, :cond_10

    invoke-virtual {v0}, Landroid/view/View;->isShown()Z

    move-result v1

    if-nez v1, :cond_1c

    :cond_10
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v1

    div-int/lit8 v1, v1, 0x2

    invoke-static {p0, v1}, Lcom/zing/zalo/zsplit/ZSplit;->findList(Landroid/view/View;I)Landroid/view/ViewGroup;

    move-result-object v0

    if-eqz v0, :cond_58

    :cond_1c
    check-cast v0, Landroid/view/ViewGroup;

    invoke-virtual {v0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    const/4 v2, 0x0

    :goto_23
    if-ge v2, v1, :cond_58

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    invoke-virtual {v3}, Landroid/view/View;->getTop()I

    move-result v4

    if-ltz v4, :cond_55

    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v5

    if-lez v5, :cond_55

    invoke-virtual {v3}, Landroid/view/View;->getLeft()I

    move-result v6

    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v7

    div-int/lit8 v7, v7, 0x2

    add-int/2addr v6, v7

    int-to-float v6, v6

    div-int/lit8 v5, v5, 0x2

    add-int/2addr v4, v5

    int-to-float v7, v4

    const-string v4, "ZDuo"

    const-string v5, "tap first conversation"

    invoke-static {v4, v5}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v8

    invoke-static {v0, v8, v9, v6, v7}, Lcom/zing/zalo/zsplit/ZSplit;->tap(Landroid/view/ViewGroup;JFF)V

    const/4 v0, 0x1

    return v0

    :cond_55
    add-int/lit8 v2, v2, 0x1

    goto :goto_23

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_58

    :catch_58
    :cond_58
    const/4 v0, 0x0

    return v0
.end method

.method static clsAt(Ljava/util/ArrayList;I)Ljava/lang/Class;
    .locals 1

    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result v0

    if-ge p1, v0, :cond_11

    if-ltz p1, :cond_11

    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Llio;

    iget-object v0, v0, Llio;->a:Ljava/lang/Class;

    return-object v0

    :cond_11
    const/4 v0, 0x0

    return-object v0
.end method

.method static countPanes(Landroid/view/View;Landroid/view/View;)I
    .locals 6

    instance-of v0, p0, Landroid/view/ViewGroup;

    if-nez v0, :cond_6

    const/4 v0, 0x0

    return v0

    :cond_6
    check-cast p0, Landroid/view/ViewGroup;

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v0

    const/4 v1, 0x0

    const/4 v2, 0x0

    :goto_e
    if-ge v1, v0, :cond_35

    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    if-eq v3, p1, :cond_32

    instance-of v4, v3, Lcom/zing/zalo/zview/SlideAnimationLayout;

    if-eqz v4, :cond_32

    invoke-virtual {v3}, Landroid/view/View;->getVisibility()I

    move-result v4

    if-nez v4, :cond_32

    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v4

    if-lez v4, :cond_32

    invoke-virtual {v3}, Landroid/view/View;->getRight()I

    move-result v4

    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v5

    if-gt v4, v5, :cond_32

    add-int/lit8 v2, v2, 0x1

    :cond_32
    add-int/lit8 v1, v1, 0x1

    goto :goto_e

    :cond_35
    return v2
.end method

.method static deco(Landroid/view/View;Ljava/lang/Class;ILandroid/view/View;)Z
    .locals 2

    :try_start_0
    if-lez p2, :cond_b

    const-class v0, Lcom/zing/zalo/ui/chat/ChatView;

    if-eq p1, v0, :cond_b

    invoke-static {p0, p3}, Lcom/zing/zalo/zsplit/ZSplit;->layer(Landroid/view/View;Landroid/view/View;)V

    const/4 v0, 0x1

    return v0

    :cond_b
    invoke-static {p0}, Lcom/zing/zalo/zsplit/ZSplit;->unlayer(Landroid/view/View;)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_e

    :catch_e
    const/4 v0, 0x0

    return v0
.end method

.method static decoDuo(Ljava/util/ArrayList;ILandroid/view/View;Ljava/lang/Class;I)Z
    .locals 4

    :try_start_0
    if-lez p4, :cond_2e

    const-class v0, Lcom/zing/zalo/ui/chat/ChatView;

    if-eq p3, v0, :cond_2e

    invoke-static {p0}, Lcom/zing/zalo/zsplit/ZSplit;->findMain(Ljava/util/ArrayList;)I

    move-result v0

    if-ltz v0, :cond_2e

    add-int/lit8 v0, v0, 0x1

    :goto_e
    if-gt v0, p1, :cond_2e

    invoke-virtual {p0, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Llio;

    iget-object v1, v1, Llio;->a:Ljava/lang/Class;

    invoke-static {v1}, Lcom/zing/zalo/zsplit/ZSplit;->isGear(Ljava/lang/Class;)Z

    move-result v1

    if-nez v1, :cond_21

    add-int/lit8 v0, v0, 0x1

    goto :goto_e

    :cond_21
    invoke-virtual {p2}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    check-cast v1, Landroid/view/View;

    if-eqz v1, :cond_2e

    invoke-static {p2, v1}, Lcom/zing/zalo/zsplit/ZSplit;->layer(Landroid/view/View;Landroid/view/View;)V

    const/4 v0, 0x1

    return v0

    :cond_2e
    invoke-static {p2}, Lcom/zing/zalo/zsplit/ZSplit;->unlayer(Landroid/view/View;)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_31

    :catch_31
    const/4 v0, 0x0

    return v0
.end method

.method static desc(Ljava/util/ArrayList;)Ljava/lang/String;
    .locals 5

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result v1

    const/4 v2, 0x0

    :goto_a
    if-ge v2, v1, :cond_25

    invoke-virtual {p0, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Llio;

    iget-object v3, v3, Llio;->a:Ljava/lang/Class;

    if-eqz v3, :cond_1d

    invoke-virtual {v3}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_1d
    const-string v3, " > "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v2, v2, 0x1

    goto :goto_a

    :cond_25
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method static diag(Landroid/view/View;)V
    .locals 9

    sget v0, Lcom/zing/zalo/zsplit/ZSplit;->sDiagN:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/zing/zalo/zsplit/ZSplit;->sDiagN:I

    rem-int/lit8 v0, v0, 0x14

    if-eqz v0, :cond_b

    return-void

    :cond_b
    :try_start_b
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    if-lez v0, :cond_89

    add-int/lit8 v0, v0, 0x4

    new-instance v1, Ljava/util/ArrayDeque;

    invoke-direct {v1}, Ljava/util/ArrayDeque;-><init>()V

    invoke-virtual {v1, p0}, Ljava/util/ArrayDeque;->add(Ljava/lang/Object;)Z

    :cond_1b
    invoke-virtual {v1}, Ljava/util/ArrayDeque;->poll()Ljava/lang/Object;

    move-result-object v2

    if-eqz v2, :cond_89

    check-cast v2, Landroid/view/View;

    invoke-virtual {v2}, Landroid/view/View;->getWidth()I

    move-result v3

    if-le v3, v0, :cond_6c

    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v4

    sget-object v5, Lcom/zing/zalo/zsplit/ZSplit;->sSeen:Ljava/util/HashSet;

    invoke-virtual {v5, v4}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_89

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "ZSplit wide: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, " < "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, " w="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    const-string v7, "ZSplit"

    invoke-static {v7, v6}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_89

    :cond_6c
    instance-of v4, v2, Landroid/view/ViewGroup;

    if-eqz v4, :cond_1b

    check-cast v2, Landroid/view/ViewGroup;

    invoke-virtual {v2}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v4

    const/4 v5, 0x0

    :goto_77
    if-ge v5, v4, :cond_1b

    invoke-virtual {v2, v5}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v6

    invoke-virtual {v6}, Landroid/view/View;->getVisibility()I

    move-result v7

    if-nez v7, :cond_86

    invoke-virtual {v1, v6}, Ljava/util/ArrayDeque;->add(Ljava/lang/Object;)Z

    :cond_86
    add-int/lit8 v5, v5, 0x1

    goto :goto_77

    :try_end_b
    .catch Ljava/lang/Throwable; {:try_start_b .. :try_end_b} :catch_89

    :catch_89
    :cond_89
    :goto_89
    return-void
.end method

.method static dlog(Ljava/util/ArrayList;Landroid/view/View;II)V
    .locals 8

    :try_start_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mode="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " main="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " wide="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Lcom/zing/zalo/zsplit/ZSplit;->isWide(Landroid/view/View;)Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " |"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result v2

    const/4 v3, 0x0

    :goto_2b
    if-ge v3, v2, :cond_79

    invoke-virtual {p0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Llio;

    const-string v1, " "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, v4, Llio;->a:Ljava/lang/Class;

    if-eqz v5, :cond_4f

    invoke-virtual {v5}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "/pane="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v5}, Lcom/zing/zalo/zsplit/ZSplit;->isPane(Ljava/lang/Class;)Z

    move-result v6

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    :cond_4f
    iget-object v5, v4, Llio;->b:Lu1w;

    if-eqz v5, :cond_76

    iget-object v5, v5, Lu1w;->x:Landroid/view/View;

    if-eqz v5, :cond_76

    const-string v1, "/vis="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Landroid/view/View;->getVisibility()I

    move-result v6

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, "/par="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v6

    if-ne v6, p1, :cond_71

    const-string v1, "C"

    goto :goto_73

    :cond_71
    const-string v1, "X"

    :goto_73
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_76
    add-int/lit8 v3, v3, 0x1

    goto :goto_2b

    :cond_79
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sget-object v1, Lcom/zing/zalo/zsplit/ZSplit;->sLast:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_ba

    sput-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sLast:Ljava/lang/String;

    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v1

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/content/Context;->getExternalFilesDir(Ljava/lang/String;)Ljava/io/File;

    move-result-object v1

    if-eqz v1, :cond_ba

    new-instance v2, Ljava/io/File;

    const-string v3, "zsplit.log"

    invoke-direct {v2, v1, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    new-instance v1, Ljava/io/FileWriter;

    const/4 v3, 0x1

    invoke-direct {v1, v2, v3}, Ljava/io/FileWriter;-><init>(Ljava/io/File;Z)V

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-static {v2, v3}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/io/Writer;->write(Ljava/lang/String;)V

    const-string v2, " "

    invoke-virtual {v1, v2}, Ljava/io/Writer;->write(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/io/Writer;->write(Ljava/lang/String;)V

    const-string v2, "\n"

    invoke-virtual {v1, v2}, Ljava/io/Writer;->write(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/Writer;->close()V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_ba

    :catch_ba
    :cond_ba
    return-void
.end method

.method static dock(Landroid/view/View;Z)V
    .locals 12

    const-string v0, "sliding_tabs"

    invoke-static {p0, v0}, Lcom/zing/zalo/zsplit/ZSplit;->idOf(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object v0

    if-nez v0, :cond_9

    return-void

    :cond_9
    const-string v1, "pager"

    invoke-static {p0, v1}, Lcom/zing/zalo/zsplit/ZSplit;->idOf(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object v1

    invoke-virtual {v0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v2

    iget v2, v2, Landroid/util/DisplayMetrics;->density:F

    invoke-virtual {v0}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;

    move-result-object v3

    instance-of v4, v3, Lcom/zing/zalo/zsplit/ZGlass;

    if-nez v4, :cond_69

    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v4

    instance-of v5, v4, Landroid/view/ViewGroup$MarginLayoutParams;

    if-eqz v5, :cond_38

    check-cast v4, Landroid/view/ViewGroup$MarginLayoutParams;

    const/high16 v5, 0x41600000    # 14.0f

    mul-float/2addr v5, v2

    float-to-int v5, v5

    iput v5, v4, Landroid/view/ViewGroup$MarginLayoutParams;->leftMargin:I

    iput v5, v4, Landroid/view/ViewGroup$MarginLayoutParams;->rightMargin:I

    iput v5, v4, Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I

    invoke-virtual {v0, v4}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :cond_38
    new-instance v3, Lcom/zing/zalo/zsplit/ZGlass;

    invoke-direct {v3, v0, v1}, Lcom/zing/zalo/zsplit/ZGlass;-><init>(Landroid/view/View;Landroid/view/View;)V

    invoke-virtual {v0, v3}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    new-instance v4, Lcom/zing/zalo/zsplit/ZFore;

    invoke-direct {v4, v3}, Lcom/zing/zalo/zsplit/ZFore;-><init>(Lcom/zing/zalo/zsplit/ZGlass;)V

    invoke-virtual {v0, v4}, Landroid/view/View;->setForeground(Landroid/graphics/drawable/Drawable;)V

    new-instance v4, Lcom/zing/zalo/zsplit/ZOutline;

    const/high16 v5, -0x40800000

    invoke-direct {v4, v5}, Lcom/zing/zalo/zsplit/ZOutline;-><init>(F)V

    invoke-virtual {v0, v4}, Landroid/view/View;->setOutlineProvider(Landroid/view/ViewOutlineProvider;)V

    const/4 v4, 0x0

    invoke-virtual {v0, v4}, Landroid/view/View;->setClipToOutline(Z)V

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v5

    instance-of v6, v5, Landroid/view/ViewGroup;

    if-eqz v6, :cond_63

    check-cast v5, Landroid/view/ViewGroup;

    invoke-virtual {v5, v4}, Landroid/view/ViewGroup;->setClipChildren(Z)V

    :cond_63
    const/high16 v4, 0x41400000    # 12.0f

    mul-float/2addr v4, v2

    invoke-virtual {v0, v4}, Landroid/view/View;->setElevation(F)V

    :cond_69
    check-cast v3, Lcom/zing/zalo/zsplit/ZGlass;

    instance-of v4, v0, Landroid/view/ViewGroup;

    if-eqz v4, :cond_ee

    move-object v4, v0

    check-cast v4, Landroid/view/ViewGroup;

    invoke-virtual {v4}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v5

    const/4 v6, 0x0

    :goto_77
    if-ge v6, v5, :cond_a4

    invoke-virtual {v4, v6}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v7

    invoke-virtual {v7}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;

    move-result-object v8

    if-eqz v8, :cond_87

    const/4 v8, 0x0

    invoke-virtual {v7, v8}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    :cond_87
    invoke-virtual {v7}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v8

    const-string v9, "RevealView"

    invoke-virtual {v8, v9}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v8

    if-eqz v8, :cond_a1

    invoke-virtual {v7}, Landroid/view/View;->getVisibility()I

    move-result v8

    if-nez v8, :cond_a1

    const/4 v8, 0x4

    invoke-virtual {v7, v8}, Landroid/view/View;->setVisibility(I)V

    :cond_a1
    add-int/lit8 v6, v6, 0x1

    goto :goto_77

    :cond_a4
    invoke-virtual {v3}, Lcom/zing/zalo/zsplit/ZGlass;->tabs()Landroid/view/ViewGroup;

    move-result-object v4

    if-eqz v4, :cond_ee

    invoke-virtual {v4}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v5

    const/4 v6, 0x0

    :goto_af
    if-ge v6, v5, :cond_ee

    invoke-virtual {v4, v6}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v7

    invoke-virtual {v7}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;

    move-result-object v8

    if-eqz v8, :cond_bf

    const/4 v8, 0x0

    invoke-virtual {v7, v8}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    :cond_bf
    invoke-virtual {v7}, Landroid/view/View;->getForeground()Landroid/graphics/drawable/Drawable;

    move-result-object v8

    if-eqz v8, :cond_c9

    const/4 v8, 0x0

    invoke-virtual {v7, v8}, Landroid/view/View;->setForeground(Landroid/graphics/drawable/Drawable;)V

    :cond_c9
    invoke-static {v7}, Lcom/zing/zalo/zsplit/ZSplit;->noRipple(Landroid/view/View;)V

    sget-object v8, Lcom/zing/zalo/zsplit/ZSplit;->sDock:Ljava/util/WeakHashMap;

    if-nez v8, :cond_d7

    new-instance v8, Ljava/util/WeakHashMap;

    invoke-direct {v8}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v8, Lcom/zing/zalo/zsplit/ZSplit;->sDock:Ljava/util/WeakHashMap;

    :cond_d7
    invoke-virtual {v8, v7}, Ljava/util/WeakHashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v9

    if-nez v9, :cond_eb

    new-instance v9, Lcom/zing/zalo/zsplit/ZDrag;

    invoke-direct {v9, v3}, Lcom/zing/zalo/zsplit/ZDrag;-><init>(Lcom/zing/zalo/zsplit/ZGlass;)V

    invoke-virtual {v7, v9}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    invoke-virtual {v7}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;

    invoke-virtual {v8, v7, v9}, Ljava/util/WeakHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_eb
    add-int/lit8 v6, v6, 0x1

    goto :goto_af

    :cond_ee
    invoke-virtual {v3}, Lcom/zing/zalo/zsplit/ZGlass;->tick()V

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v4

    instance-of v5, v4, Lcom/zing/zalo/uicontrol/MainTabFrameLayout;

    if-eqz v5, :cond_121

    check-cast v4, Lcom/zing/zalo/uicontrol/MainTabFrameLayout;

    invoke-virtual {v0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v5

    const-string v6, "height_tab_main"

    const-string v7, "dimen"

    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v8

    invoke-virtual {v8}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v5, v6, v7, v8}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v6

    if-eqz v6, :cond_121

    invoke-virtual {v5, v6}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result v6

    invoke-virtual {v4}, Lcom/zing/zalo/uicontrol/MainTabFrameLayout;->getBottomSpacing()I

    move-result v7

    if-ltz v7, :cond_121

    if-ge v7, v6, :cond_121

    sub-int/2addr v7, v6

    invoke-virtual {v4, v7}, Lcom/zing/zalo/uicontrol/MainTabFrameLayout;->setBottomSpacing(I)V

    :cond_121
    sget v4, Lcom/zing/zalo/zsplit/ZSplit;->sPadT:I

    add-int/lit8 v4, v4, 0x1

    sput v4, Lcom/zing/zalo/zsplit/ZSplit;->sPadT:I

    rem-int/lit8 v4, v4, 0xf

    if-nez v4, :cond_142

    if-eqz v1, :cond_142

    invoke-virtual {v0}, Landroid/view/View;->getHeight()I

    move-result v4

    if-lez v4, :cond_142

    const/high16 v5, 0x41a00000    # 20.0f

    mul-float/2addr v5, v2

    float-to-int v5, v5

    add-int/2addr v4, v5

    invoke-virtual {v1}, Landroid/view/View;->getHeight()I

    move-result v5

    div-int/lit8 v5, v5, 0x2

    const/4 v6, 0x0

    invoke-static {v1, v4, v5, v6}, Lcom/zing/zalo/zsplit/ZSplit;->padLists(Landroid/view/View;III)V

    :cond_142
    return-void
.end method

.method static dockAll(Ljava/util/ArrayList;ILandroid/view/View;)V
    .locals 2

    :try_start_0
    if-ltz p1, :cond_14

    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Llio;

    iget-object v0, v0, Llio;->b:Lu1w;

    if-eqz v0, :cond_14

    iget-object v0, v0, Lu1w;->x:Landroid/view/View;

    if-eqz v0, :cond_14

    const/4 v1, 0x1

    invoke-static {v0, v1}, Lcom/zing/zalo/zsplit/ZSplit;->dock(Landroid/view/View;Z)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_14

    :catch_14
    :cond_14
    return-void
.end method

.method static findList(Landroid/view/View;I)Landroid/view/ViewGroup;
    .locals 6

    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_43

    invoke-virtual {p0}, Landroid/view/View;->isShown()Z

    move-result v0

    if-eqz v0, :cond_43

    check-cast p0, Landroid/view/ViewGroup;

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-static {v0}, Lcom/zing/zalo/zsplit/ZSplit;->isList(Ljava/lang/Class;)Z

    move-result v0

    if-eqz v0, :cond_2e

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v0

    if-lt v0, p1, :cond_2e

    new-instance v0, Landroid/graphics/Rect;

    invoke-direct {v0}, Landroid/graphics/Rect;-><init>()V

    invoke-virtual {p0, v0}, Landroid/view/View;->getGlobalVisibleRect(Landroid/graphics/Rect;)Z

    move-result v1

    if-eqz v1, :cond_2e

    invoke-virtual {v0}, Landroid/graphics/Rect;->width()I

    move-result v1

    if-lez v1, :cond_2e

    return-object p0

    :cond_2e
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    const/4 v2, 0x0

    :goto_33
    if-ge v2, v1, :cond_43

    invoke-virtual {p0, v2}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    invoke-static {v3, p1}, Lcom/zing/zalo/zsplit/ZSplit;->findList(Landroid/view/View;I)Landroid/view/ViewGroup;

    move-result-object v3

    if-eqz v3, :cond_40

    return-object v3

    :cond_40
    add-int/lit8 v2, v2, 0x1

    goto :goto_33

    :cond_43
    const/4 v0, 0x0

    return-object v0
.end method

.method static findMain(Ljava/util/ArrayList;)I
    .locals 5

    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    const-class v2, Lcom/zing/zalo/ui/maintab/MainTabView;

    :goto_8
    if-ltz v0, :cond_18

    invoke-virtual {p0, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Llio;

    iget-object v1, v1, Llio;->a:Ljava/lang/Class;

    if-ne v1, v2, :cond_15

    return v0

    :cond_15
    add-int/lit8 v0, v0, -0x1

    goto :goto_8

    :cond_18
    const/4 v0, -0x1

    return v0
.end method

.method static findShownId(Landroid/view/View;I)Landroid/view/View;
    .locals 5

    invoke-virtual {p0}, Landroid/view/View;->getVisibility()I

    move-result v0

    if-nez v0, :cond_2f

    invoke-virtual {p0}, Landroid/view/View;->getId()I

    move-result v0

    if-ne v0, p1, :cond_13

    invoke-virtual {p0}, Landroid/view/View;->isShown()Z

    move-result v0

    if-eqz v0, :cond_13

    return-object p0

    :cond_13
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_2f

    move-object v0, p0

    check-cast v0, Landroid/view/ViewGroup;

    invoke-virtual {v0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    const/4 v2, 0x0

    :goto_1f
    if-ge v2, v1, :cond_2f

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    invoke-static {v3, p1}, Lcom/zing/zalo/zsplit/ZSplit;->findShownId(Landroid/view/View;I)Landroid/view/View;

    move-result-object v3

    if-eqz v3, :cond_2c

    return-object v3

    :cond_2c
    add-int/lit8 v2, v2, 0x1

    goto :goto_1f

    :cond_2f
    const/4 v0, 0x0

    return-object v0
.end method

.method static findText(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;
    .locals 4

    invoke-virtual {p0}, Landroid/view/View;->getVisibility()I

    move-result v0

    if-nez v0, :cond_3e

    instance-of v0, p0, Landroid/widget/TextView;

    if-eqz v0, :cond_22

    move-object v0, p0

    check-cast v0, Landroid/widget/TextView;

    invoke-virtual {v0}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v0

    if-eqz v0, :cond_3e

    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_3e

    return-object p0

    :cond_22
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_3e

    move-object v0, p0

    check-cast v0, Landroid/view/ViewGroup;

    invoke-virtual {v0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    const/4 v2, 0x0

    :goto_2e
    if-ge v2, v1, :cond_3e

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    invoke-static {v3, p1}, Lcom/zing/zalo/zsplit/ZSplit;->findText(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object v3

    if-eqz v3, :cond_3b

    return-object v3

    :cond_3b
    add-int/lit8 v2, v2, 0x1

    goto :goto_2e

    :cond_3e
    const/4 v0, 0x0

    return-object v0
.end method

.method static fixDock(Landroid/view/View;I)V
    .locals 4

    const-string v0, "sliding_tabs"

    invoke-static {p0, v0}, Lcom/zing/zalo/zsplit/ZSplit;->idOf(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object v0

    if-eqz v0, :cond_1e

    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    instance-of v2, v1, Landroid/view/ViewGroup$MarginLayoutParams;

    if-eqz v2, :cond_1e

    check-cast v1, Landroid/view/ViewGroup$MarginLayoutParams;

    iget v2, v1, Landroid/view/ViewGroup$MarginLayoutParams;->leftMargin:I

    add-int/2addr v2, p1

    iget v3, v1, Landroid/view/ViewGroup$MarginLayoutParams;->rightMargin:I

    if-eq v3, v2, :cond_1e

    iput v2, v1, Landroid/view/ViewGroup$MarginLayoutParams;->rightMargin:I

    invoke-virtual {v0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :cond_1e
    return-void
.end method

.method public static fixW(II)I
    .locals 2

    const/high16 v0, -0x40000000

    and-int/2addr v0, p1

    if-nez v0, :cond_6

    return p0

    :cond_6
    const v0, 0x3fffffff

    and-int/2addr v0, p1

    if-lez v0, :cond_f

    if-ge v0, p0, :cond_f

    return v0

    :cond_f
    return p0
.end method

.method static hideZV(Landroid/view/View;)V
    .locals 11

    :try_start_0
    sget v0, Lcom/zing/zalo/zsplit/ZSplit;->sZVn:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/zing/zalo/zsplit/ZSplit;->sZVn:I

    rem-int/lit8 v0, v0, 0x6

    if-nez v0, :cond_9a

    const-string v0, "tab_recycler_view"

    invoke-static {p0, v0}, Lcom/zing/zalo/zsplit/ZSplit;->rid(Landroid/view/View;Ljava/lang/String;)I

    move-result v0

    if-eqz v0, :cond_9a

    invoke-static {p0, v0}, Lcom/zing/zalo/zsplit/ZSplit;->findShownId(Landroid/view/View;I)Landroid/view/View;

    move-result-object v1

    instance-of v2, v1, Landroid/view/ViewGroup;

    if-eqz v2, :cond_9a

    check-cast v1, Landroid/view/ViewGroup;

    invoke-virtual {v1}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v2

    const/4 v3, 0x2

    if-lt v2, v3, :cond_9a

    const-string v2, "lv_media_store"

    invoke-static {p0, v2}, Lcom/zing/zalo/zsplit/ZSplit;->rid(Landroid/view/View;Ljava/lang/String;)I

    move-result v2

    if-eqz v2, :cond_82

    invoke-static {p0, v2}, Lcom/zing/zalo/zsplit/ZSplit;->findShownId(Landroid/view/View;I)Landroid/view/View;

    move-result-object v2

    if-eqz v2, :cond_82

    new-instance v3, Landroid/graphics/Rect;

    invoke-direct {v3}, Landroid/graphics/Rect;-><init>()V

    invoke-virtual {v2, v3}, Landroid/view/View;->getGlobalVisibleRect(Landroid/graphics/Rect;)Z

    move-result v4

    if-eqz v4, :cond_82

    invoke-virtual {v3}, Landroid/graphics/Rect;->width()I

    move-result v4

    const/16 v5, 0x64

    if-le v4, v5, :cond_82

    const/4 v4, 0x0

    invoke-virtual {v1, v4}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v4

    const/4 v5, 0x2

    new-array v5, v5, [I

    invoke-virtual {v4, v5}, Landroid/view/View;->getLocationInWindow([I)V

    const/4 v6, 0x2

    new-array v6, v6, [I

    invoke-virtual {p0, v6}, Landroid/view/View;->getLocationInWindow([I)V

    const/4 v7, 0x0

    aget v8, v5, v7

    aget v9, v6, v7

    sub-int/2addr v8, v9

    invoke-virtual {v4}, Landroid/view/View;->getWidth()I

    move-result v9

    div-int/lit8 v9, v9, 0x2

    add-int/2addr v8, v9

    int-to-float v8, v8

    const/4 v7, 0x1

    aget v9, v5, v7

    aget v10, v6, v7

    sub-int/2addr v9, v10

    invoke-virtual {v4}, Landroid/view/View;->getHeight()I

    move-result v10

    div-int/lit8 v10, v10, 0x2

    add-int/2addr v9, v10

    int-to-float v9, v9

    const-string v5, "ZDuo"

    const-string v6, "Zalo Video showing -> Nhat Ky"

    invoke-static {v5, v6}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v5

    move-object v7, p0

    check-cast v7, Landroid/view/ViewGroup;

    invoke-static {v7, v5, v6, v8, v9}, Lcom/zing/zalo/zsplit/ZSplit;->tap(Landroid/view/ViewGroup;JFF)V

    :cond_82
    invoke-virtual {v1}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v2

    const/4 v3, 0x1

    :goto_87
    if-ge v3, v2, :cond_9a

    invoke-virtual {v1, v3}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v4

    invoke-virtual {v4}, Landroid/view/View;->getVisibility()I

    move-result v5

    const/4 v6, 0x4

    if-eq v5, v6, :cond_97

    invoke-virtual {v4, v6}, Landroid/view/View;->setVisibility(I)V

    :cond_97
    add-int/lit8 v3, v3, 0x1

    goto :goto_87

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_9a

    :catch_9a
    :cond_9a
    return-void
.end method

.method static idOf(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;
    .locals 3

    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const-string v1, "id"

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, p1, v1, v2}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v0

    if-eqz v0, :cond_19

    invoke-virtual {p0, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    return-object v0

    :cond_19
    const/4 v0, 0x0

    return-object v0
.end method

.method static install(Lcom/zing/zalo/zview/b;Landroid/view/View;)V
    .locals 2

    sget-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sContainer:Ljava/lang/ref/WeakReference;

    if-eqz v0, :cond_b

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    if-ne v0, p1, :cond_b

    return-void

    :cond_b
    new-instance v0, Lcom/zing/zalo/zsplit/ZSplit;

    invoke-direct {v0, p0, p1}, Lcom/zing/zalo/zsplit/ZSplit;-><init>(Lcom/zing/zalo/zview/b;Landroid/view/View;)V

    invoke-virtual {p1}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v1

    invoke-virtual {v1, v0}, Landroid/view/ViewTreeObserver;->addOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    new-instance v1, Ljava/lang/ref/WeakReference;

    invoke-direct {v1, p1}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    sput-object v1, Lcom/zing/zalo/zsplit/ZSplit;->sContainer:Ljava/lang/ref/WeakReference;

    return-void
.end method

.method static isGear(Ljava/lang/Class;)Z
    .locals 2

    if-eqz p0, :cond_16

    invoke-virtual {p0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    const-string v1, "com.zing.zalo.ui.settings.SettingV2View"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_18

    const-string v1, "com.zing.zalo.ui.settings.SettingView"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_18

    :cond_16
    const/4 v0, 0x0

    return v0

    :cond_18
    const/4 v0, 0x1

    return v0
.end method

.method static isList(Ljava/lang/Class;)Z
    .locals 4

    sget-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sIsList:Ljava/util/HashMap;

    if-nez v0, :cond_b

    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sIsList:Ljava/util/HashMap;

    :cond_b
    invoke-virtual {v0, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Boolean;

    if-eqz v1, :cond_18

    invoke-virtual {v1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v1

    return v1

    :cond_18
    move-object v1, p0

    const/4 v3, 0x0

    :goto_1a
    if-eqz v1, :cond_35

    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v2

    const-string v3, "RecyclerView"

    invoke-virtual {v2, v3}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_35

    const-string v3, "android.widget.AbsListView"

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_35

    invoke-virtual {v1}, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;

    move-result-object v1

    goto :goto_1a

    :cond_35
    invoke-static {v3}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v2

    invoke-virtual {v0, p0, v2}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return v3
.end method

.method static isMainHost(Landroid/view/ViewGroup;Landroid/view/View;)Z
    .locals 3

    :try_start_0
    invoke-static {p0}, Lcom/zing/zalo/zsplit/ZSplit;->isWide(Landroid/view/View;)Z

    move-result v0

    if-eqz v0, :cond_3c

    sget-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sMainV:Ljava/lang/ref/WeakReference;

    if-eqz v0, :cond_14

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    if-ne v0, p1, :cond_14

    const/4 v0, 0x1

    return v0

    :cond_14
    instance-of v0, p1, Landroid/view/ViewGroup;

    if-eqz v0, :cond_3c

    const-string v0, "sliding_tabs"

    invoke-static {p1, v0}, Lcom/zing/zalo/zsplit/ZSplit;->idOf(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object v0

    if-eqz v0, :cond_24

    const/4 v0, 0x1

    return v0

    :cond_24
    move-object v0, p1

    check-cast v0, Landroid/view/ViewGroup;

    invoke-virtual {v0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    if-lez v1, :cond_3c

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    const-string v2, "MainTabFrameLayout"

    invoke-virtual {v0, v2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v0

    return v0
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_3c

    :catch_3c
    :cond_3c
    const/4 v0, 0x0

    return v0
.end method

.method static isOurs(Landroid/view/View;)Z
    .locals 2

    sget-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sFeedV:Ljava/lang/ref/WeakReference;

    if-eqz v0, :cond_c

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    if-ne v0, p0, :cond_c

    const/4 v0, 0x1

    return v0

    :cond_c
    sget-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sNotifV:Ljava/lang/ref/WeakReference;

    if-eqz v0, :cond_18

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    if-ne v0, p0, :cond_18

    const/4 v0, 0x1

    return v0

    :cond_18
    const/4 v0, 0x0

    return v0
.end method

.method public static isPane(Ljava/lang/Class;)Z
    .locals 5

    if-nez p0, :cond_4

    const/4 v0, 0x0

    return v0

    :cond_4
    const-class v0, Lcom/zing/zalo/ui/chat/ChatView;

    if-ne p0, v0, :cond_a

    const/4 v0, 0x1

    return v0

    :cond_a
    const-class v0, Lprv;

    invoke-virtual {v0, p0}, Ljava/lang/Class;->isAssignableFrom(Ljava/lang/Class;)Z

    move-result v0

    if-nez v0, :cond_fd

    invoke-virtual {p0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    const/16 v1, 0x23

    new-array v1, v1, [Ljava/lang/String;

    const/16 v2, 0x0

    const-string v3, "Camera"

    aput-object v3, v1, v2

    const/16 v2, 0x1

    const-string v3, "Photo"

    aput-object v3, v1, v2

    const/16 v2, 0x2

    const-string v3, "Gallery"

    aput-object v3, v1, v2

    const/16 v2, 0x3

    const-string v3, "Media"

    aput-object v3, v1, v2

    const/16 v2, 0x4

    const-string v3, "Video"

    aput-object v3, v1, v2

    const/16 v2, 0x5

    const-string v3, "Story"

    aput-object v3, v1, v2

    const/16 v2, 0x6

    const-string v3, "Call"

    aput-object v3, v1, v2

    const/16 v2, 0x7

    const-string v3, "Viewer"

    aput-object v3, v1, v2

    const/16 v2, 0x8

    const-string v3, "Preview"

    aput-object v3, v1, v2

    const/16 v2, 0x9

    const-string v3, "Crop"

    aput-object v3, v1, v2

    const/16 v2, 0xa

    const-string v3, "Bottom"

    aput-object v3, v1, v2

    const/16 v2, 0xb

    const-string v3, "Popup"

    aput-object v3, v1, v2

    const/16 v2, 0xc

    const-string v3, "Dialog"

    aput-object v3, v1, v2

    const/16 v2, 0xd

    const-string v3, "Scan"

    aput-object v3, v1, v2

    const/16 v2, 0xe

    const-string v3, "QR"

    aput-object v3, v1, v2

    const/16 v2, 0xf

    const-string v3, "Qr"

    aput-object v3, v1, v2

    const/16 v2, 0x10

    const-string v3, "Map"

    aput-object v3, v1, v2

    const/16 v2, 0x11

    const-string v3, "Location"

    aput-object v3, v1, v2

    const/16 v2, 0x12

    const-string v3, "Sticker"

    aput-object v3, v1, v2

    const/16 v2, 0x13

    const-string v3, "Emoji"

    aput-object v3, v1, v2

    const/16 v2, 0x14

    const-string v3, "Doodle"

    aput-object v3, v1, v2

    const/16 v2, 0x15

    const-string v3, "Draw"

    aput-object v3, v1, v2

    const/16 v2, 0x16

    const-string v3, "Editor"

    aput-object v3, v1, v2

    const/16 v2, 0x17

    const-string v3, "Login"

    aput-object v3, v1, v2

    const/16 v2, 0x18

    const-string v3, "Onboard"

    aput-object v3, v1, v2

    const/16 v2, 0x19

    const-string v3, "Splash"

    aput-object v3, v1, v2

    const/16 v2, 0x1a

    const-string v3, "Fullscreen"

    aput-object v3, v1, v2

    const/16 v2, 0x1b

    const-string v3, "FullScreen"

    aput-object v3, v1, v2

    const/16 v2, 0x1c

    const-string v3, "MainTab"

    aput-object v3, v1, v2

    const/16 v2, 0x1d

    const-string v3, "Zch"

    aput-object v3, v1, v2

    const/16 v2, 0x1e

    const-string v3, "Short"

    aput-object v3, v1, v2

    const/16 v2, 0x1f

    const-string v3, "Live"

    aput-object v3, v1, v2

    const/16 v2, 0x20

    const-string v3, "Game"

    aput-object v3, v1, v2

    const/16 v2, 0x21

    const-string v3, "MiniApp"

    aput-object v3, v1, v2

    const/16 v2, 0x22

    const-string v3, "Web"

    aput-object v3, v1, v2

    array-length v2, v1

    const/4 v3, 0x0

    :goto_ee
    if-ge v3, v2, :cond_fb

    aget-object v4, v1, v3

    invoke-virtual {v0, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v4

    if-nez v4, :cond_fd

    add-int/lit8 v3, v3, 0x1

    goto :goto_ee

    :cond_fb
    const/4 v0, 0x1

    return v0

    :cond_fd
    const/4 v0, 0x0

    return v0
.end method

.method static isWide(Landroid/view/View;)Z
    .locals 5

    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v1

    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v2

    if-lez v0, :cond_14

    if-gtz v1, :cond_18

    :cond_14
    iget v0, v2, Landroid/util/DisplayMetrics;->widthPixels:I

    iget v1, v2, Landroid/util/DisplayMetrics;->heightPixels:I

    :cond_18
    iget v2, v2, Landroid/util/DisplayMetrics;->density:F

    int-to-float v3, v0

    div-float/2addr v3, v2

    const/high16 v4, 0x44160000    # 600.0f

    cmpl-float v4, v3, v4

    if-gez v4, :cond_2e

    const/high16 v4, 0x43be0000    # 380.0f

    cmpl-float v4, v3, v4

    if-ltz v4, :cond_30

    mul-int/lit8 v3, v0, 0xa

    mul-int/lit8 v4, v1, 0x8

    if-lt v3, v4, :cond_30

    :cond_2e
    const/4 v0, 0x1

    return v0

    :cond_30
    const/4 v0, 0x0

    return v0
.end method

.method public static keepAlive(Lo3e;Lv2e;)Z
    .locals 6

    :try_start_0
    iget-object v0, p0, Lo3e;->e:Ljava/lang/ref/WeakReference;

    if-eqz v0, :cond_69

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_69

    sget-object v1, Lv2e;->ON_PAUSE:Lv2e;

    sget-object v2, Lv2e;->ON_STOP:Lv2e;

    instance-of v3, v0, Landroid/app/Activity;

    if-eqz v3, :cond_22

    if-eq p1, v1, :cond_1e

    if-eq p1, v2, :cond_1e

    sget-object v3, Lv2e;->ON_RESUME:Lv2e;

    if-ne p1, v3, :cond_69

    const/4 v3, 0x0

    sput-boolean v3, Lcom/zing/zalo/zsplit/ZSplit;->sActP:Z

    goto :goto_69

    :cond_1e
    const/4 v3, 0x1

    sput-boolean v3, Lcom/zing/zalo/zsplit/ZSplit;->sActP:Z

    goto :goto_69

    :cond_22
    if-eq p1, v1, :cond_26

    if-ne p1, v2, :cond_69

    :cond_26
    sget-boolean v3, Lcom/zing/zalo/zsplit/ZSplit;->sActP:Z

    if-nez v3, :cond_69

    instance-of v3, v0, Ly1w;

    if-eqz v3, :cond_2f

    sget-object v3, Lcom/zing/zalo/zsplit/ZSplit;->sKeepVLO:Ljava/util/WeakHashMap;

    invoke-virtual {v3, v0}, Ljava/util/WeakHashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_69

    sget-object v3, Lcom/zing/zalo/zsplit/ZSplit;->sMainV:Ljava/lang/ref/WeakReference;

    if-eqz v3, :cond_69

    invoke-virtual {v3}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/view/View;

    if-eqz v3, :cond_69

    invoke-virtual {v3}, Landroid/view/View;->getVisibility()I

    move-result v4

    if-nez v4, :cond_69

    invoke-virtual {v3}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v4

    instance-of v5, v4, Landroid/view/View;

    if-eqz v5, :cond_69

    check-cast v4, Landroid/view/View;

    invoke-static {v4}, Lcom/zing/zalo/zsplit/ZSplit;->isWide(Landroid/view/View;)Z

    move-result v5

    if-eqz v5, :cond_69

    const/4 v0, 0x1

    return v0

    :cond_2f
    instance-of v3, v0, Lu1w;

    if-eqz v3, :cond_69

    check-cast v0, Lu1w;

    iget-object v0, v0, Lu1w;->x:Landroid/view/View;

    if-eqz v0, :cond_69

    sget-object v3, Lcom/zing/zalo/zsplit/ZSplit;->sMainV:Ljava/lang/ref/WeakReference;

    if-eqz v3, :cond_69

    invoke-virtual {v3}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/view/View;

    if-eqz v3, :cond_69

    invoke-virtual {v3}, Landroid/view/View;->getVisibility()I

    move-result v4

    if-nez v4, :cond_69

    invoke-virtual {v3}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v4

    instance-of v5, v4, Landroid/view/View;

    if-eqz v5, :cond_69

    check-cast v4, Landroid/view/View;

    invoke-static {v4}, Lcom/zing/zalo/zsplit/ZSplit;->isWide(Landroid/view/View;)Z

    move-result v5

    if-eqz v5, :cond_69

    move-object v4, v0

    :goto_57
    if-eqz v4, :cond_69

    if-ne v4, v3, :cond_5d

    const/4 v0, 0x1

    return v0

    :cond_5d
    invoke-virtual {v4}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v5

    instance-of p0, v5, Landroid/view/View;

    if-eqz p0, :cond_69

    move-object v4, v5

    check-cast v4, Landroid/view/View;

    goto :goto_57

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_69

    :catch_69
    :cond_69
    :goto_69
    const/4 v0, 0x0

    return v0
.end method

.method public static keepMainState(Lcom/zing/zalo/zview/b;Llio;I)Z
    .locals 3

    :try_start_0
    if-eqz p0, :cond_3c

    if-eqz p1, :cond_3c

    iget-object v0, p1, Llio;->a:Ljava/lang/Class;

    const-class v1, Lcom/zing/zalo/ui/maintab/MainTabView;

    if-ne v0, v1, :cond_3c

    const/4 v0, 0x3

    if-lt p2, v0, :cond_3c

    const/4 v0, 0x5

    if-ge p2, v0, :cond_3c

    iget v1, p0, Lcom/zing/zalo/zview/b;->i:I

    if-lt v1, v0, :cond_3c

    sget-boolean v1, Lcom/zing/zalo/zsplit/ZSplit;->sActP:Z

    if-nez v1, :cond_3c

    iget-object v1, p1, Llio;->b:Lu1w;

    if-eqz v1, :cond_3c

    iget v2, v1, Lu1w;->a:I

    if-lt v2, v0, :cond_3c

    iget-object v1, v1, Lu1w;->x:Landroid/view/View;

    if-eqz v1, :cond_3c

    invoke-virtual {v1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    instance-of v2, v1, Landroid/view/View;

    if-eqz v2, :cond_3c

    check-cast v1, Landroid/view/View;

    invoke-static {v1}, Lcom/zing/zalo/zsplit/ZSplit;->isWide(Landroid/view/View;)Z

    move-result v1

    if-eqz v1, :cond_3c

    const/4 v0, 0x1

    return v0
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_3c

    :catch_3c
    :cond_3c
    const/4 v0, 0x0

    return v0
.end method

.method static keepMain(Ljava/util/ArrayList;Landroid/view/View;)V
    .locals 7

    :try_start_0
    invoke-static {p1}, Lcom/zing/zalo/zsplit/ZSplit;->isWide(Landroid/view/View;)Z

    move-result v0

    if-eqz v0, :cond_48

    invoke-static {p0}, Lcom/zing/zalo/zsplit/ZSplit;->findMain(Ljava/util/ArrayList;)I

    move-result v1

    if-ltz v1, :cond_48

    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result v2

    add-int/lit8 v3, v1, 0x1

    if-ge v3, v2, :cond_48

    :goto_14
    if-ge v3, v2, :cond_27

    invoke-virtual {p0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Llio;

    iget-object v4, v4, Llio;->a:Ljava/lang/Class;

    invoke-static {v4}, Lcom/zing/zalo/zsplit/ZSplit;->isPane(Ljava/lang/Class;)Z

    move-result v4

    if-eqz v4, :cond_48

    add-int/lit8 v3, v3, 0x1

    goto :goto_14

    :cond_27
    invoke-virtual {p0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Llio;

    iget-object v4, v4, Llio;->b:Lu1w;

    if-eqz v4, :cond_48

    iget-object v4, v4, Lu1w;->x:Landroid/view/View;

    if-eqz v4, :cond_48

    invoke-virtual {v4}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v5

    if-ne v5, p1, :cond_48

    invoke-virtual {v4}, Landroid/view/View;->getVisibility()I

    move-result v5

    if-eqz v5, :cond_45

    const/4 v5, 0x0

    invoke-virtual {v4, v5}, Landroid/view/View;->setVisibility(I)V

    :cond_45
    invoke-static {p0, p1, v1}, Lcom/zing/zalo/zsplit/ZSplit;->showChats(Ljava/util/ArrayList;Landroid/view/View;I)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_48

    :catch_48
    :cond_48
    return-void
.end method

.method static layer(Landroid/view/View;Landroid/view/View;)V
    .locals 9

    invoke-virtual {p1}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    iget v0, v0, Landroid/util/DisplayMetrics;->density:F

    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v1

    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result v2

    if-lez v1, :cond_91

    if-lez v2, :cond_91

    int-to-float v3, v1

    const v4, 0x3f28f5c3    # 0.66f

    mul-float/2addr v3, v4

    float-to-int v3, v3

    const/high16 v4, 0x44160000    # 600.0f

    mul-float/2addr v4, v0

    float-to-int v4, v4

    if-le v3, v4, :cond_23

    move v3, v4

    :cond_23
    int-to-float v4, v2

    const v5, 0x3f63d70a    # 0.89f

    mul-float/2addr v4, v5

    float-to-int v4, v4

    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v5

    instance-of v6, v5, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz v6, :cond_91

    check-cast v5, Landroid/widget/FrameLayout$LayoutParams;

    iget v6, v5, Landroid/widget/FrameLayout$LayoutParams;->width:I

    if-ne v6, v3, :cond_45

    iget v6, v5, Landroid/widget/FrameLayout$LayoutParams;->height:I

    if-ne v6, v4, :cond_45

    iget v6, v5, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    const/16 v7, 0x11

    if-ne v6, v7, :cond_45

    iget v6, v5, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    if-eqz v6, :cond_53

    :cond_45
    iput v3, v5, Landroid/widget/FrameLayout$LayoutParams;->width:I

    iput v4, v5, Landroid/widget/FrameLayout$LayoutParams;->height:I

    const/16 v7, 0x11

    iput v7, v5, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    const/4 v7, 0x0

    iput v7, v5, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    invoke-virtual {p0, v5}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :cond_53
    const/4 v6, 0x0

    invoke-static {v6}, Lcom/zing/zalo/zsplit/ZSplit;->map(I)Ljava/util/WeakHashMap;

    move-result-object v6

    invoke-virtual {v6, p0}, Ljava/util/WeakHashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v7

    if-nez v7, :cond_91

    sget-object v7, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v6, p0, v7}, Ljava/util/WeakHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const/high16 v7, 0x41e00000    # 28.0f

    mul-float/2addr v7, v0

    new-instance v8, Lcom/zing/zalo/zsplit/ZOutline;

    invoke-direct {v8, v7}, Lcom/zing/zalo/zsplit/ZOutline;-><init>(F)V

    invoke-virtual {p0, v8}, Landroid/view/View;->setOutlineProvider(Landroid/view/ViewOutlineProvider;)V

    const/4 v8, 0x1

    invoke-virtual {p0, v8}, Landroid/view/View;->setClipToOutline(Z)V

    const/high16 v8, 0x41c00000    # 24.0f

    mul-float/2addr v8, v0

    invoke-virtual {p0, v8}, Landroid/view/View;->setElevation(F)V

    new-instance v8, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v8}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    invoke-virtual {v8, v7}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    const/4 v1, 0x0

    invoke-virtual {v8, v1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/high16 v1, 0x3fc00000    # 1.5f

    mul-float/2addr v1, v0

    float-to-int v1, v1

    const v2, 0x73ffffff

    invoke-virtual {v8, v1, v2}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    invoke-virtual {p0, v8}, Landroid/view/View;->setForeground(Landroid/graphics/drawable/Drawable;)V

    :cond_91
    return-void
.end method

.method static map(I)Ljava/util/WeakHashMap;
    .locals 1

    if-nez p0, :cond_e

    sget-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sLay:Ljava/util/WeakHashMap;

    if-nez v0, :cond_d

    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sLay:Ljava/util/WeakHashMap;

    :cond_d
    return-object v0

    :cond_e
    sget-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sBlur:Ljava/util/WeakHashMap;

    if-nez v0, :cond_19

    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sBlur:Ljava/util/WeakHashMap;

    :cond_19
    return-object v0
.end method

.method static noRipple(Landroid/view/View;)V
    .locals 4

    invoke-virtual {p0}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;

    move-result-object v0

    instance-of v0, v0, Landroid/graphics/drawable/RippleDrawable;

    if-eqz v0, :cond_c

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    :cond_c
    invoke-virtual {p0}, Landroid/view/View;->getForeground()Landroid/graphics/drawable/Drawable;

    move-result-object v0

    instance-of v0, v0, Landroid/graphics/drawable/RippleDrawable;

    if-eqz v0, :cond_18

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/view/View;->setForeground(Landroid/graphics/drawable/Drawable;)V

    :cond_18
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_2f

    check-cast p0, Landroid/view/ViewGroup;

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    const/4 v2, 0x0

    :goto_23
    if-ge v2, v1, :cond_2f

    invoke-virtual {p0, v2}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    invoke-static {v3}, Lcom/zing/zalo/zsplit/ZSplit;->noRipple(Landroid/view/View;)V

    add-int/lit8 v2, v2, 0x1

    goto :goto_23

    :cond_2f
    return-void
.end method

.method static currentTab(Ljava/util/ArrayList;I)I
    .locals 3

    :try_start_0
    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Llio;

    if-eqz v0, :cond_41

    iget-object v0, v0, Llio;->b:Lu1w;

    instance-of v1, v0, Lcom/zing/zalo/ui/maintab/MainTabView;

    if-eqz v1, :cond_41

    check-cast v0, Lcom/zing/zalo/ui/maintab/MainTabView;

    invoke-virtual {v0}, Lcom/zing/zalo/ui/maintab/MainTabView;->y6()I

    move-result v0

    if-ltz v0, :cond_41

    invoke-static {}, Lscf;->h()Lscf;

    move-result-object v1

    if-eqz v1, :cond_41

    invoke-virtual {v1}, Lscf;->k()I

    move-result v2

    if-ne v0, v2, :cond_26

    const/4 v0, 0x1

    return v0

    :cond_26
    invoke-virtual {v1}, Lscf;->l()I

    move-result v2

    if-ne v0, v2, :cond_2f

    const/4 v0, 0x2

    return v0

    :cond_2f
    invoke-virtual {v1}, Lscf;->n()I

    move-result v2

    if-ne v0, v2, :cond_38

    const/4 v0, 0x3

    return v0

    :cond_38
    invoke-virtual {v1}, Lscf;->i()I

    move-result v2

    if-ne v0, v2, :cond_41

    const/4 v0, 0x4

    return v0
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_41

    :catch_41
    :cond_41
    const/4 v0, 0x0

    return v0
.end method

.method static flog(Landroid/content/Context;Ljava/lang/String;)V
    .locals 4

    :try_start_0
    const-string v0, "ZDuo"

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    if-eqz p0, :cond_31

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/content/Context;->getExternalFilesDir(Ljava/lang/String;)Ljava/io/File;

    move-result-object v0

    if-eqz v0, :cond_31

    new-instance v1, Ljava/io/File;

    const-string v2, "zsplit.log"

    invoke-direct {v1, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    new-instance v0, Ljava/io/FileWriter;

    const/4 v2, 0x1

    invoke-direct {v0, v1, v2}, Ljava/io/FileWriter;-><init>(Ljava/io/File;Z)V

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-static {v2, v3}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/io/Writer;->write(Ljava/lang/String;)V

    const-string v1, " [ZDuo] "

    invoke-virtual {v0, v1}, Ljava/io/Writer;->write(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/io/Writer;->write(Ljava/lang/String;)V

    const-string v1, "\n"

    invoke-virtual {v0, v1}, Ljava/io/Writer;->write(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/Writer;->close()V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_31

    :catch_31
    :cond_31
    return-void
.end method

.method static isDefaultPane(Ljava/lang/Class;)Z
    .locals 1

    const-class v0, Lcom/zing/zalo/ui/chat/ChatView;

    if-eq p0, v0, :cond_18

    const-class v0, Lcom/zing/zalo/ui/zviews/RequestFriendView;

    if-eq p0, v0, :cond_18

    const-class v0, Lcom/zing/zalo/social/presentation/profile/own_profile/MyProfileView;

    if-eq p0, v0, :cond_18

    const-class v0, Lcom/zing/zalo/social/features/notification/list_notification/presentation/NotificationView;

    if-eq p0, v0, :cond_18

    const/4 v0, 0x0

    return v0

    :cond_18
    const/4 v0, 0x1

    return v0
.end method

.method static syncDock(Ljava/util/ArrayList;ILandroid/view/View;)V
    .locals 4

    :try_start_0
    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Llio;

    if-eqz v0, :cond_3d

    iget-object v0, v0, Llio;->b:Lu1w;

    instance-of v1, v0, Lcom/zing/zalo/ui/maintab/MainTabView;

    if-eqz v1, :cond_3d

    check-cast v0, Lcom/zing/zalo/ui/maintab/MainTabView;

    invoke-virtual {v0}, Lcom/zing/zalo/ui/maintab/MainTabView;->y6()I

    move-result v0

    if-ltz v0, :cond_3d

    invoke-static {p0, p1, v0}, Lcom/zing/zalo/zsplit/ZSplit;->wakeTab(Ljava/util/ArrayList;II)V

    const-string v1, "sliding_tabs"

    invoke-static {p2, v1}, Lcom/zing/zalo/zsplit/ZSplit;->idOf(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object v1

    instance-of v2, v1, Lcom/zing/zalo/ui/maintab/widget/CustomMainTab;

    if-eqz v2, :cond_3d

    check-cast v1, Lcom/zing/zalo/ui/maintab/widget/CustomMainTab;

    invoke-virtual {v1, v0}, Lcom/zing/zalo/ui/maintab/widget/CustomMainTab;->e(I)Landroid/view/View;

    move-result-object v2

    if-eqz v2, :cond_3d

    const-string v3, "iconActive"

    invoke-static {v2, v3}, Lcom/zing/zalo/zsplit/ZSplit;->idOf(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object v2

    if-eqz v2, :cond_3d

    invoke-virtual {v2}, Landroid/view/View;->getVisibility()I

    move-result v2

    if-eqz v2, :cond_3d

    invoke-virtual {v1, v0}, Lcom/zing/zalo/ui/maintab/widget/CustomMainTab;->h(I)V

    invoke-virtual {v1}, Landroid/view/View;->invalidate()V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_3d

    :catch_3d
    :cond_3d
    return-void
.end method

.method static wakeTab(Ljava/util/ArrayList;II)V
    .locals 4

    :try_start_0
    if-ltz p2, :cond_5a

    sget-boolean v0, Lcom/zing/zalo/zsplit/ZSplit;->sActP:Z

    if-nez v0, :cond_5a

    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Llio;

    if-eqz v0, :cond_5a

    iget-object v0, v0, Llio;->b:Lu1w;

    instance-of v1, v0, Lcom/zing/zalo/ui/maintab/MainTabView;

    if-eqz v1, :cond_5a

    check-cast v0, Lcom/zing/zalo/ui/maintab/MainTabView;

    invoke-virtual {v0, p2}, Lcom/zing/zalo/ui/maintab/MainTabView;->v6(I)Lu1w;

    move-result-object v0

    if-eqz v0, :cond_5a

    iget-object v1, v0, Lu1w;->D:Ly1w;

    if-eqz v1, :cond_3b

    sget-object v2, Lcom/zing/zalo/zsplit/ZSplit;->sKeepVLO:Ljava/util/WeakHashMap;

    sget-object v3, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v2, v1, v3}, Ljava/util/WeakHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    invoke-virtual {v1}, Ly1w;->b()V

    iget-object v2, v1, Ly1w;->a:Lo3e;

    if-eqz v2, :cond_3b

    iget-object v2, v2, Lo3e;->d:Lw2e;

    sget-object v3, Lw2e;->RESUMED:Lw2e;

    if-eq v2, v3, :cond_3b

    sget-object v3, Lw2e;->DESTROYED:Lw2e;

    if-eq v2, v3, :cond_3b

    sget-object v2, Lv2e;->ON_RESUME:Lv2e;

    invoke-virtual {v1, v2}, Ly1w;->a(Lv2e;)V

    :cond_3b
    invoke-virtual {v0}, Lu1w;->getLifecycle()Lx2e;

    move-result-object v1

    instance-of v2, v1, Lo3e;

    if-eqz v2, :cond_5a

    check-cast v1, Lo3e;

    iget-object v2, v1, Lo3e;->d:Lw2e;

    sget-object v3, Lw2e;->RESUMED:Lw2e;

    if-eq v2, v3, :cond_5a

    sget-object v3, Lw2e;->DESTROYED:Lw2e;

    if-eq v2, v3, :cond_5a

    sget-object v2, Lv2e;->ON_RESUME:Lv2e;

    invoke-virtual {v1, v2}, Lo3e;->e(Lv2e;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_5a

    :catch_5a
    :cond_5a
    return-void
.end method

.method static wantClass(I)Ljava/lang/Class;
    .locals 1

    const/4 v0, 0x1

    if-ne p0, v0, :cond_8

    const-class v0, Lcom/zing/zalo/ui/chat/ChatView;

    return-object v0

    :cond_8
    const/4 v0, 0x2

    if-ne p0, v0, :cond_10

    const-class v0, Lcom/zing/zalo/ui/zviews/RequestFriendView;

    return-object v0

    :cond_10
    const/4 v0, 0x4

    if-ne p0, v0, :cond_18

    const-class v0, Lcom/zing/zalo/social/presentation/profile/own_profile/MyProfileView;

    return-object v0

    :cond_18
    const/4 v0, 0x0

    return-object v0
.end method

.method public static onShow(Lcom/zing/zalo/zview/b;ILjava/lang/Class;Landroid/os/Bundle;)Landroid/os/Bundle;
    .locals 9

    const-class v0, Lcom/zing/zalo/ui/maintab/MainTabView;

    if-ne p2, v0, :cond_8

    invoke-static {p0}, Lcom/zing/zalo/zsplit/ZRetry;->schedule(Lcom/zing/zalo/zview/b;)V

    return-object p3

    :cond_8
    invoke-static {p2}, Lcom/zing/zalo/zsplit/ZSplit;->isDefaultPane(Ljava/lang/Class;)Z

    move-result v0

    if-nez v0, :cond_11

    return-object p3

    :cond_11
    iget-object v1, p0, Lcom/zing/zalo/zview/b;->d:Ljava/util/ArrayList;

    if-nez v1, :cond_16

    return-object p3

    :cond_16
    :try_start_16
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "onShow "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, " stack="

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v1}, Lcom/zing/zalo/zsplit/ZSplit;->desc(Ljava/util/ArrayList;)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v2

    invoke-static {v1}, Lcom/zing/zalo/zsplit/ZSplit;->findMain(Ljava/util/ArrayList;)I

    move-result v3

    if-ltz v3, :cond_a4

    invoke-virtual {v1, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Llio;

    iget-object v4, v4, Llio;->b:Lu1w;

    if-eqz v4, :cond_a4

    iget-object v4, v4, Lu1w;->x:Landroid/view/View;

    if-eqz v4, :cond_a4

    invoke-virtual {v4}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v4

    instance-of v5, v4, Landroid/view/View;

    if-eqz v5, :cond_a4

    check-cast v4, Landroid/view/View;

    invoke-static {p0, v4}, Lcom/zing/zalo/zsplit/ZSplit;->install(Lcom/zing/zalo/zview/b;Landroid/view/View;)V

    invoke-static {v4}, Lcom/zing/zalo/zsplit/ZSplit;->isWide(Landroid/view/View;)Z

    move-result v5

    const-string v8, " wide="

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    if-eqz v5, :cond_a4

    if-nez v3, :cond_a4

    const/4 v5, 0x1

    if-le v2, v5, :cond_a4

    add-int/lit8 v5, v2, -0x1

    invoke-virtual {v1, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Llio;

    iget-object v5, v5, Llio;->a:Ljava/lang/Class;

    invoke-static {v5}, Lcom/zing/zalo/zsplit/ZSplit;->isDefaultPane(Ljava/lang/Class;)Z

    move-result v5

    if-eqz v5, :cond_a4

    if-nez p3, :cond_93

    new-instance v6, Landroid/os/Bundle;

    invoke-direct {v6}, Landroid/os/Bundle;-><init>()V

    move-object p3, v6

    :cond_93
    const-string v5, "SHOW_WITH_FLAGS"

    invoke-virtual {p3, v5}, Landroid/os/BaseBundle;->getInt(Ljava/lang/String;)I

    move-result v6

    const/high16 v4, 0x700000

    or-int/2addr v6, v4

    invoke-virtual {p3, v5, v6}, Landroid/os/BaseBundle;->putInt(Ljava/lang/String;I)V

    const-string v8, " replace"

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_a4
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-static {v1, v8}, Lcom/zing/zalo/zsplit/ZSplit;->toast(Ljava/util/ArrayList;Ljava/lang/String;)V
    :try_end_16
    .catch Ljava/lang/Throwable; {:try_start_16 .. :try_end_16} :catch_ac

    return-object p3

    :catch_ac
    move-exception v8

    invoke-virtual {v8}, Ljava/lang/Throwable;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-static {v1, v8}, Lcom/zing/zalo/zsplit/ZSplit;->toast(Ljava/util/ArrayList;Ljava/lang/String;)V

    return-object p3
.end method

.method static padLists(Landroid/view/View;III)V
    .locals 6

    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_55

    const/16 v0, 0xc

    if-gt p3, v0, :cond_55

    invoke-virtual {p0}, Landroid/view/View;->getVisibility()I

    move-result v0

    const/16 v1, 0x8

    if-eq v0, v1, :cond_55

    check-cast p0, Landroid/view/ViewGroup;

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-static {v0}, Lcom/zing/zalo/zsplit/ZSplit;->isList(Ljava/lang/Class;)Z

    move-result v0

    if-eqz v0, :cond_42

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v0

    if-lt v0, p2, :cond_42

    invoke-virtual {p0}, Landroid/view/View;->getPaddingBottom()I

    move-result v0

    if-ge v0, p1, :cond_37

    invoke-virtual {p0}, Landroid/view/View;->getPaddingLeft()I

    move-result v0

    invoke-virtual {p0}, Landroid/view/View;->getPaddingTop()I

    move-result v1

    invoke-virtual {p0}, Landroid/view/View;->getPaddingRight()I

    move-result v2

    invoke-virtual {p0, v0, v1, v2, p1}, Landroid/view/View;->setPadding(IIII)V

    :cond_37
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getClipToPadding()Z

    move-result v0

    if-eqz v0, :cond_55

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->setClipToPadding(Z)V

    goto :goto_55

    :cond_42
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v0

    const/4 v1, 0x0

    add-int/lit8 v3, p3, 0x1

    :goto_49
    if-ge v1, v0, :cond_55

    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    invoke-static {v2, p1, p2, v3}, Lcom/zing/zalo/zsplit/ZSplit;->padLists(Landroid/view/View;III)V

    add-int/lit8 v1, v1, 0x1

    goto :goto_49

    :cond_55
    :goto_55
    return-void
.end method

.method static ref(Landroid/view/View;)Ljava/lang/ref/WeakReference;
    .locals 1

    new-instance v0, Ljava/lang/ref/WeakReference;

    invoke-direct {v0, p0}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    return-object v0
.end method

.method static rid(Landroid/view/View;Ljava/lang/String;)I
    .locals 3

    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const-string v1, "id"

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, p1, v1, v2}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v0

    return v0
.end method

.method static rootAt(Ljava/util/ArrayList;I)Landroid/view/View;
    .locals 1

    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Llio;

    iget-object v0, v0, Llio;->b:Lu1w;

    if-eqz v0, :cond_d

    iget-object v0, v0, Lu1w;->x:Landroid/view/View;

    return-object v0

    :cond_d
    const/4 v0, 0x0

    return-object v0
.end method

.method static scrim(Landroid/view/View;Z)V
    .locals 5

    :try_start_0
    instance-of v0, p0, Landroid/widget/FrameLayout;

    if-eqz v0, :cond_5d

    sget-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sScrim:Ljava/util/WeakHashMap;

    if-nez v0, :cond_f

    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sScrim:Ljava/util/WeakHashMap;

    :cond_f
    invoke-virtual {v0, p0}, Ljava/util/WeakHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/View;

    if-eqz v1, :cond_1e

    invoke-virtual {v1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    if-ne v2, p0, :cond_1e

    goto :goto_4f

    :cond_1e
    if-nez p1, :cond_21

    return-void

    :cond_21
    new-instance v1, Landroid/view/View;

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    new-instance v2, Lcom/zing/zalo/zsplit/ZBack;

    invoke-direct {v2}, Lcom/zing/zalo/zsplit/ZBack;-><init>()V

    invoke-virtual {v1, v2}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v2

    iget v2, v2, Landroid/util/DisplayMetrics;->density:F

    invoke-virtual {v1, v2}, Landroid/view/View;->setTranslationZ(F)V

    new-instance v2, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v3, -0x1

    invoke-direct {v2, v3, v3}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    move-object v3, p0

    check-cast v3, Landroid/view/ViewGroup;

    const/4 v4, 0x0

    invoke-virtual {v3, v1, v4, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;ILandroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v0, p0, v1}, Ljava/util/WeakHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_4f
    const/16 v2, 0x8

    if-eqz p1, :cond_54

    const/4 v2, 0x0

    :cond_54
    invoke-virtual {v1}, Landroid/view/View;->getVisibility()I

    move-result v3

    if-eq v3, v2, :cond_5d

    invoke-virtual {v1, v2}, Landroid/view/View;->setVisibility(I)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_5d

    :catch_5d
    :cond_5d
    return-void
.end method

.method static show(Landroid/view/View;)V
    .locals 1

    if-eqz p0, :cond_c

    invoke-virtual {p0}, Landroid/view/View;->getVisibility()I

    move-result v0

    if-eqz v0, :cond_c

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/view/View;->setVisibility(I)V

    :cond_c
    return-void
.end method

.method static showChats(Ljava/util/ArrayList;Landroid/view/View;I)V
    .locals 6

    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result v0

    add-int/lit8 v1, v0, -0x1

    invoke-virtual {p0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Llio;

    iget-object v1, v1, Llio;->a:Ljava/lang/Class;

    const-class v2, Lcom/zing/zalo/ui/chat/ChatView;

    if-ne v1, v2, :cond_13

    return-void

    :cond_13
    add-int/lit8 v3, p2, 0x1

    :goto_15
    if-ge v3, v0, :cond_3c

    invoke-virtual {p0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Llio;

    iget-object v5, v4, Llio;->a:Ljava/lang/Class;

    if-ne v5, v2, :cond_39

    iget-object v4, v4, Llio;->b:Lu1w;

    if-eqz v4, :cond_39

    iget-object v4, v4, Lu1w;->x:Landroid/view/View;

    if-eqz v4, :cond_39

    invoke-virtual {v4}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v5

    if-ne v5, p1, :cond_39

    invoke-virtual {v4}, Landroid/view/View;->getVisibility()I

    move-result v5

    if-eqz v5, :cond_39

    const/4 v5, 0x0

    invoke-virtual {v4, v5}, Landroid/view/View;->setVisibility(I)V

    :cond_39
    add-int/lit8 v3, v3, 0x1

    goto :goto_15

    :cond_3c
    return-void
.end method

.method static tabOn(Landroid/view/View;Ljava/lang/String;)Z
    .locals 4

    invoke-static {p0, p1}, Lcom/zing/zalo/zsplit/ZSplit;->idOf(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object v0

    if-eqz v0, :cond_20

    const-string v1, "iconActive"

    invoke-static {v0, v1}, Lcom/zing/zalo/zsplit/ZSplit;->idOf(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object v1

    if-eqz v1, :cond_20

    invoke-virtual {v1}, Landroid/view/View;->getVisibility()I

    move-result v2

    if-nez v2, :cond_20

    invoke-virtual {v1}, Landroid/view/View;->getAlpha()F

    move-result v2

    const/high16 v3, 0x3f000000    # 0.5f

    cmpl-float v2, v2, v3

    if-lez v2, :cond_20

    const/4 v0, 0x1

    return v0

    :cond_20
    const/4 v0, 0x0

    return v0
.end method

.method static tap(Landroid/view/ViewGroup;JFF)V
    .locals 9

    const/4 v6, 0x0

    move-wide v0, p1

    move-wide v2, p1

    const/4 v4, 0x0

    move v5, p3

    move v6, p4

    const/4 v7, 0x0

    invoke-static/range {v0 .. v7}, Landroid/view/MotionEvent;->obtain(JJIFFI)Landroid/view/MotionEvent;

    move-result-object v8

    invoke-virtual {p0, v8}, Landroid/view/ViewGroup;->dispatchTouchEvent(Landroid/view/MotionEvent;)Z

    invoke-virtual {v8}, Landroid/view/MotionEvent;->recycle()V

    const-wide/16 v2, 0x32

    add-long/2addr v2, p1

    const/4 v4, 0x1

    invoke-static/range {v0 .. v7}, Landroid/view/MotionEvent;->obtain(JJIFFI)Landroid/view/MotionEvent;

    move-result-object v8

    invoke-virtual {p0, v8}, Landroid/view/ViewGroup;->dispatchTouchEvent(Landroid/view/MotionEvent;)Z

    invoke-virtual {v8}, Landroid/view/MotionEvent;->recycle()V

    return-void
.end method

.method static tapText(Landroid/view/View;Ljava/lang/String;)Z
    .locals 12

    :try_start_0
    invoke-static {p0, p1}, Lcom/zing/zalo/zsplit/ZSplit;->findText(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object v0

    if-eqz v0, :cond_44

    invoke-virtual {v0}, Landroid/view/View;->isShown()Z

    move-result v1

    if-eqz v1, :cond_44

    const/4 v1, 0x2

    new-array v1, v1, [I

    invoke-virtual {v0, v1}, Landroid/view/View;->getLocationInWindow([I)V

    const/4 v2, 0x2

    new-array v2, v2, [I

    invoke-virtual {p0, v2}, Landroid/view/View;->getLocationInWindow([I)V

    const/4 v3, 0x0

    aget v4, v1, v3

    aget v5, v2, v3

    sub-int/2addr v4, v5

    invoke-virtual {v0}, Landroid/view/View;->getWidth()I

    move-result v5

    div-int/lit8 v5, v5, 0x2

    add-int/2addr v4, v5

    int-to-float v4, v4

    const/4 v3, 0x1

    aget v5, v1, v3

    aget v6, v2, v3

    sub-int/2addr v5, v6

    invoke-virtual {v0}, Landroid/view/View;->getHeight()I

    move-result v6

    div-int/lit8 v6, v6, 0x2

    add-int/2addr v5, v6

    int-to-float v5, v5

    const-string v6, "ZDuo"

    invoke-static {v6, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v6

    check-cast p0, Landroid/view/ViewGroup;

    invoke-static {p0, v6, v7, v4, v5}, Lcom/zing/zalo/zsplit/ZSplit;->tap(Landroid/view/ViewGroup;JFF)V

    const/4 v0, 0x1

    return v0

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_44

    :catch_44
    :cond_44
    const/4 v0, 0x0

    return v0
.end method

.method static tlActive(Landroid/view/View;)Z
    .locals 5

    const-string v0, "maintab_timeline"

    invoke-static {p0, v0}, Lcom/zing/zalo/zsplit/ZSplit;->idOf(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object v0

    if-eqz v0, :cond_22

    const-string v1, "iconActive"

    invoke-static {v0, v1}, Lcom/zing/zalo/zsplit/ZSplit;->idOf(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object v1

    if-eqz v1, :cond_22

    invoke-virtual {v1}, Landroid/view/View;->getVisibility()I

    move-result v2

    if-nez v2, :cond_22

    invoke-virtual {v1}, Landroid/view/View;->getAlpha()F

    move-result v2

    const/high16 v3, 0x3f000000    # 0.5f

    cmpl-float v2, v2, v3

    if-lez v2, :cond_22

    const/4 v0, 0x1

    return v0

    :cond_22
    const/4 v0, 0x0

    return v0
.end method

.method static toast(Ljava/util/ArrayList;Ljava/lang/String;)V
    .locals 1

    const-string v0, "ZSplit"

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public static tryInstall(Lcom/zing/zalo/zview/b;)Z
    .locals 4

    iget-object v0, p0, Lcom/zing/zalo/zview/b;->d:Ljava/util/ArrayList;

    if-eqz v0, :cond_2a

    invoke-static {v0}, Lcom/zing/zalo/zsplit/ZSplit;->findMain(Ljava/util/ArrayList;)I

    move-result v1

    if-ltz v1, :cond_2a

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Llio;

    iget-object v2, v2, Llio;->b:Lu1w;

    if-eqz v2, :cond_2a

    iget-object v2, v2, Lu1w;->x:Landroid/view/View;

    if-eqz v2, :cond_2a

    invoke-virtual {v2}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    instance-of v3, v2, Landroid/view/View;

    if-eqz v3, :cond_2a

    check-cast v2, Landroid/view/View;

    invoke-static {p0, v2}, Lcom/zing/zalo/zsplit/ZSplit;->install(Lcom/zing/zalo/zview/b;Landroid/view/View;)V

    invoke-virtual {v2}, Landroid/view/View;->invalidate()V

    const/4 v0, 0x1

    return v0

    :cond_2a
    const/4 v0, 0x0

    return v0
.end method

.method static unblur(Landroid/view/View;)V
    .locals 1

    :try_start_0
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/view/View;->setRenderEffect(Landroid/graphics/RenderEffect;)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_4

    :catch_4
    return-void
.end method

.method static unlayer(Landroid/view/View;)V
    .locals 3

    const/4 v0, 0x0

    invoke-static {v0}, Lcom/zing/zalo/zsplit/ZSplit;->map(I)Ljava/util/WeakHashMap;

    move-result-object v0

    invoke-virtual {v0, p0}, Ljava/util/WeakHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_33

    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    instance-of v1, v0, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz v1, :cond_22

    check-cast v0, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v1, -0x1

    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    const/4 v1, 0x0

    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    invoke-virtual {p0, v0}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :cond_22
    sget-object v0, Landroid/view/ViewOutlineProvider;->BACKGROUND:Landroid/view/ViewOutlineProvider;

    invoke-virtual {p0, v0}, Landroid/view/View;->setOutlineProvider(Landroid/view/ViewOutlineProvider;)V

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/view/View;->setClipToOutline(Z)V

    const/4 v1, 0x0

    invoke-virtual {p0, v1}, Landroid/view/View;->setElevation(F)V

    const/4 v1, 0x0

    invoke-virtual {p0, v1}, Landroid/view/View;->setForeground(Landroid/graphics/drawable/Drawable;)V

    :cond_33
    return-void
.end method

.method public static zs_addView(Landroid/view/ViewGroup;Landroid/view/View;)V
    .locals 1

    invoke-virtual {p1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    if-ne v0, p0, :cond_7

    return-void

    :cond_7
    invoke-static {p0, p1}, Lcom/zing/zalo/zsplit/ZGlass;->prePosition(Landroid/view/ViewGroup;Landroid/view/View;)V

    invoke-virtual {p0, p1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    return-void
.end method

.method public static zs_addView(Landroid/view/ViewGroup;Landroid/view/View;I)V
    .locals 1

    invoke-virtual {p1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    if-ne v0, p0, :cond_7

    return-void

    :cond_7
    invoke-static {p0, p1}, Lcom/zing/zalo/zsplit/ZGlass;->prePosition(Landroid/view/ViewGroup;Landroid/view/View;)V

    invoke-virtual {p0, p1, p2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;I)V

    return-void
.end method

.method public static zs_addView(Landroid/view/ViewGroup;Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    .locals 1

    invoke-virtual {p1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    if-ne v0, p0, :cond_a

    invoke-virtual {p1, p2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    return-void

    :cond_a
    invoke-static {p0, p1, p2}, Lcom/zing/zalo/zsplit/ZGlass;->prePosition(Landroid/view/ViewGroup;Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {p0, p1, p2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    return-void
.end method

.method public static zs_removeView(Landroid/view/ViewGroup;Landroid/view/View;)V
    .locals 1

    invoke-static {p0, p1}, Lcom/zing/zalo/zsplit/ZSplit;->isMainHost(Landroid/view/ViewGroup;Landroid/view/View;)Z

    move-result v0

    if-eqz v0, :cond_7

    return-void

    :cond_7
    invoke-virtual {p0, p1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    return-void
.end method


# virtual methods
.method dockGap(Landroid/view/View;)V
    .locals 4

    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    instance-of v1, v0, Landroid/view/ViewGroup$MarginLayoutParams;

    if-eqz v1, :cond_21

    check-cast v0, Landroid/view/ViewGroup$MarginLayoutParams;

    invoke-virtual {p1}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v1

    iget v1, v1, Landroid/util/DisplayMetrics;->density:F

    const/high16 v2, 0x42a00000    # 80.0f

    mul-float/2addr v1, v2

    float-to-int v1, v1

    iget v2, v0, Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I

    if-eq v2, v1, :cond_21

    iput v1, v0, Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I

    invoke-virtual {p1, v0}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :cond_21
    return-void
.end method

.method duo(I)I
    .locals 13

    const/4 v12, 0x0

    :try_start_0
    iget-object v0, p0, Lcom/zing/zalo/zsplit/ZSplit;->mgr:Lcom/zing/zalo/zview/b;

    if-eqz v0, :cond_165

    iget-object v1, v0, Lcom/zing/zalo/zview/b;->d:Ljava/util/ArrayList;

    if-eqz v1, :cond_165

    iget-object v2, p0, Lcom/zing/zalo/zsplit/ZSplit;->container:Landroid/view/View;

    if-eqz v2, :cond_165

    if-ltz p1, :cond_165

    invoke-virtual {v2}, Landroid/view/View;->hasWindowFocus()Z

    move-result v3

    if-nez v3, :cond_19

    const/4 v3, 0x1

    sput-boolean v3, Lcom/zing/zalo/zsplit/ZSplit;->sLost:Z

    goto :goto_22

    :cond_19
    sget-boolean v3, Lcom/zing/zalo/zsplit/ZSplit;->sLost:Z

    if-eqz v3, :cond_22

    sput-boolean v12, Lcom/zing/zalo/zsplit/ZSplit;->sLost:Z

    sput-boolean v12, Lcom/zing/zalo/zsplit/ZSplit;->sSup:Z

    :cond_22
    :goto_22
    invoke-static {v1, p1}, Lcom/zing/zalo/zsplit/ZSplit;->rootAt(Ljava/util/ArrayList;I)Landroid/view/View;

    move-result-object v3

    if-eqz v3, :cond_165

    invoke-static {v3}, Lcom/zing/zalo/zsplit/ZSplit;->ref(Landroid/view/View;)Ljava/lang/ref/WeakReference;

    move-result-object v4

    sput-object v4, Lcom/zing/zalo/zsplit/ZSplit;->sMainV:Ljava/lang/ref/WeakReference;

    invoke-static {v2}, Lcom/zing/zalo/zsplit/ZSplit;->isWide(Landroid/view/View;)Z

    move-result v4

    if-nez v4, :cond_48

    sput-boolean v12, Lcom/zing/zalo/zsplit/ZSplit;->sLastWide:Z

    const/4 v4, -0x1

    sput v4, Lcom/zing/zalo/zsplit/ZSplit;->sLastTab:I

    sput v4, Lcom/zing/zalo/zsplit/ZSplit;->sPendTab:I

    sput-boolean v12, Lcom/zing/zalo/zsplit/ZSplit;->sHadPane:Z

    sput-boolean v12, Lcom/zing/zalo/zsplit/ZSplit;->sSup:Z

    sput-boolean v12, Lcom/zing/zalo/zsplit/ZSplit;->sNeedPop:Z

    invoke-static {v3, v12}, Lcom/zing/zalo/zsplit/ZSplit;->fixDock(Landroid/view/View;I)V

    return v12

    :cond_48
    invoke-static {v1, p1}, Lcom/zing/zalo/zsplit/ZSplit;->currentTab(Ljava/util/ArrayList;I)I

    move-result v5

    if-nez v5, :cond_4f

    return v12

    :cond_4f
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v6

    add-int/lit8 v7, p1, 0x1

    if-le v6, v7, :cond_59

    const/4 v7, 0x1

    goto :goto_5a

    :cond_59
    const/4 v7, 0x0

    :goto_5a
    sget-boolean v8, Lcom/zing/zalo/zsplit/ZSplit;->sLastWide:Z

    sget v9, Lcom/zing/zalo/zsplit/ZSplit;->sLastTab:I

    if-eqz v8, :cond_62

    if-eq v5, v9, :cond_f8

    :cond_62
    const/4 v10, 0x1

    sput-boolean v10, Lcom/zing/zalo/zsplit/ZSplit;->sLastWide:Z

    sput v5, Lcom/zing/zalo/zsplit/ZSplit;->sLastTab:I

    sput-boolean v12, Lcom/zing/zalo/zsplit/ZSplit;->sSup:Z

    sput-boolean v12, Lcom/zing/zalo/zsplit/ZSplit;->sHadPane:Z

    sput v12, Lcom/zing/zalo/zsplit/ZSplit;->sPushN:I

    const/4 v10, -0x1

    sput v10, Lcom/zing/zalo/zsplit/ZSplit;->sPendTab:I

    const/4 v10, 0x3

    if-ne v5, v10, :cond_74

    const/4 v10, 0x1

    goto :goto_75

    :cond_74
    const/4 v10, 0x0

    :goto_75
    sput-boolean v10, Lcom/zing/zalo/zsplit/ZSplit;->sNeedPop:Z

    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    const-string v11, "TAB "

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v11, "->"

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v11, " wasWide="

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v8}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v11, " sz="

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v11, " stack="

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v1}, Lcom/zing/zalo/zsplit/ZSplit;->desc(Ljava/util/ArrayList;)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v2}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v11

    invoke-static {v11, v10}, Lcom/zing/zalo/zsplit/ZSplit;->flog(Landroid/content/Context;Ljava/lang/String;)V

    const/4 v10, 0x3

    if-nez v8, :cond_c1

    if-eqz v7, :cond_c1

    if-eq v5, v10, :cond_c1

    const/4 v10, 0x1

    sput-boolean v10, Lcom/zing/zalo/zsplit/ZSplit;->sHadPane:Z

    goto/16 :goto_158

    :cond_c1
    if-ne v5, v10, :cond_d6

    if-eqz v7, :cond_158

    sput-boolean v12, Lcom/zing/zalo/zsplit/ZSplit;->sNeedPop:Z

    sput v5, Lcom/zing/zalo/zsplit/ZSplit;->sPendTab:I

    new-instance v10, Lcom/zing/zalo/zsplit/ZTL;

    const/4 v11, 0x0

    const/4 v4, 0x1

    invoke-direct {v10, v0, v11, v5, v4}, Lcom/zing/zalo/zsplit/ZTL;-><init>(Lcom/zing/zalo/zview/b;Ljava/lang/Class;IZ)V

    invoke-virtual {v2, v10}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    goto/16 :goto_158

    :cond_d6
    invoke-static {v5}, Lcom/zing/zalo/zsplit/ZSplit;->wantClass(I)Ljava/lang/Class;

    move-result-object v10

    if-eqz v10, :cond_158

    const/4 v4, 0x1

    if-eq v5, v4, :cond_ea

    add-int/lit8 v4, p1, 0x2

    if-ne v6, v4, :cond_ea

    add-int/lit8 v4, p1, 0x1

    invoke-static {v1, v4}, Lcom/zing/zalo/zsplit/ZSplit;->clsAt(Ljava/util/ArrayList;I)Ljava/lang/Class;

    move-result-object v4

    if-eq v4, v10, :cond_158

    :cond_ea
    sput v5, Lcom/zing/zalo/zsplit/ZSplit;->sPendTab:I

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v8

    sput-wide v8, Lcom/zing/zalo/zsplit/ZSplit;->sPushT:J

    new-instance v11, Lcom/zing/zalo/zsplit/ZTL;

    invoke-direct {v11, v0, v10, v5, v12}, Lcom/zing/zalo/zsplit/ZTL;-><init>(Lcom/zing/zalo/zview/b;Ljava/lang/Class;IZ)V

    invoke-virtual {v2, v11}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    goto :goto_158

    :cond_f8
    const/4 v10, 0x3

    if-ne v5, v10, :cond_113

    sget-boolean v10, Lcom/zing/zalo/zsplit/ZSplit;->sNeedPop:Z

    if-eqz v10, :cond_158

    if-eqz v7, :cond_158

    invoke-static {}, Lcom/zing/zalo/zsplit/ZSplit;->canPop()Z

    move-result v10

    if-eqz v10, :cond_158

    sput-boolean v12, Lcom/zing/zalo/zsplit/ZSplit;->sNeedPop:Z

    sput v5, Lcom/zing/zalo/zsplit/ZSplit;->sPendTab:I

    new-instance v10, Lcom/zing/zalo/zsplit/ZTL;

    const/4 v11, 0x0

    const/4 v4, 0x1

    invoke-direct {v10, v0, v11, v5, v4}, Lcom/zing/zalo/zsplit/ZTL;-><init>(Lcom/zing/zalo/zview/b;Ljava/lang/Class;IZ)V

    invoke-virtual {v2, v10}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    goto :goto_158

    :cond_113
    if-eqz v7, :cond_119

    const/4 v10, 0x1

    sput-boolean v10, Lcom/zing/zalo/zsplit/ZSplit;->sHadPane:Z

    goto :goto_158

    :cond_119
    sget-boolean v10, Lcom/zing/zalo/zsplit/ZSplit;->sHadPane:Z

    if-eqz v10, :cond_13f

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v8

    sget-wide v10, Lcom/zing/zalo/zsplit/ZSplit;->sPushT:J

    sub-long/2addr v8, v10

    const-wide/16 v10, 0x258

    cmp-long v10, v8, v10

    if-ltz v10, :cond_158

    const/4 v10, 0x1

    sput-boolean v10, Lcom/zing/zalo/zsplit/ZSplit;->sSup:Z

    sput-boolean v12, Lcom/zing/zalo/zsplit/ZSplit;->sHadPane:Z

    invoke-virtual {v2}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v10

    const-string v11, "USER_BACK -> sup=true"

    invoke-static {v10, v11}, Lcom/zing/zalo/zsplit/ZSplit;->flog(Landroid/content/Context;Ljava/lang/String;)V

    goto :goto_158

    :cond_13f
    sget-boolean v10, Lcom/zing/zalo/zsplit/ZSplit;->sSup:Z

    if-nez v10, :cond_158

    sget v10, Lcom/zing/zalo/zsplit/ZSplit;->sPendTab:I

    if-eq v10, v5, :cond_158

    sget v10, Lcom/zing/zalo/zsplit/ZSplit;->sPushN:I

    const/4 v4, 0x2

    if-ge v10, v4, :cond_158

    invoke-static {}, Lcom/zing/zalo/zsplit/ZSplit;->canPush()Z

    move-result v10

    if-eqz v10, :cond_158

    invoke-static {v5}, Lcom/zing/zalo/zsplit/ZSplit;->wantClass(I)Ljava/lang/Class;

    move-result-object v10

    if-eqz v10, :cond_158

    sget v4, Lcom/zing/zalo/zsplit/ZSplit;->sPushN:I

    add-int/lit8 v4, v4, 0x1

    sput v4, Lcom/zing/zalo/zsplit/ZSplit;->sPushN:I

    sput v5, Lcom/zing/zalo/zsplit/ZSplit;->sPendTab:I

    new-instance v11, Lcom/zing/zalo/zsplit/ZTL;

    invoke-direct {v11, v0, v10, v5, v12}, Lcom/zing/zalo/zsplit/ZTL;-><init>(Lcom/zing/zalo/zview/b;Ljava/lang/Class;IZ)V

    invoke-virtual {v2, v11}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    :cond_158
    :goto_158
    const/4 v10, 0x3

    if-ne v5, v10, :cond_186

    if-nez v7, :cond_186

    invoke-virtual {v2}, Landroid/view/View;->getWidth()I

    move-result v8

    mul-int/lit8 v9, v8, 0x2

    div-int/lit8 v9, v9, 0x5

    invoke-virtual {v2}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v10

    invoke-virtual {v10}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v10

    iget v10, v10, Landroid/util/DisplayMetrics;->density:F

    const/high16 v11, 0x43d20000    # 420.0f

    mul-float/2addr v10, v11

    float-to-int v10, v10

    invoke-static {v9, v10}, Ljava/lang/Math;->min(II)I

    move-result v9

    sub-int v8, v8, v9

    if-gez v8, :cond_17b

    const/4 v8, 0x0

    :cond_17b
    invoke-static {v3, v8}, Lcom/zing/zalo/zsplit/ZSplit;->fixDock(Landroid/view/View;I)V

    invoke-static {v1, p1, v3}, Lcom/zing/zalo/zsplit/ZSplit;->syncDock(Ljava/util/ArrayList;ILandroid/view/View;)V

    const/4 v0, -0x1

    return v0

    :cond_186
    invoke-static {v3, v12}, Lcom/zing/zalo/zsplit/ZSplit;->fixDock(Landroid/view/View;I)V

    invoke-static {v1, p1, v3}, Lcom/zing/zalo/zsplit/ZSplit;->syncDock(Ljava/util/ArrayList;ILandroid/view/View;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_166

    :cond_165
    return v12

    :catch_166
    move-exception v0

    const-string v1, "ZDuo"

    const-string v2, "duo failed"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return v12
.end method

.method public onPreDraw()Z
    .locals 15

    :try_start_0
    iget-object v0, p0, Lcom/zing/zalo/zsplit/ZSplit;->mgr:Lcom/zing/zalo/zview/b;

    iget-object v0, v0, Lcom/zing/zalo/zview/b;->d:Ljava/util/ArrayList;

    if-eqz v0, :cond_e1

    iget-object v2, p0, Lcom/zing/zalo/zsplit/ZSplit;->container:Landroid/view/View;

    invoke-static {v0, v2}, Lcom/zing/zalo/zsplit/ZSplit;->keepMain(Ljava/util/ArrayList;Landroid/view/View;)V

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v1

    iget-object v2, p0, Lcom/zing/zalo/zsplit/ZSplit;->container:Landroid/view/View;

    invoke-static {v2}, Lcom/zing/zalo/zsplit/ZSplit;->isWide(Landroid/view/View;)Z

    move-result v3

    const/4 v4, 0x0

    const/4 v5, 0x0

    invoke-static {v0}, Lcom/zing/zalo/zsplit/ZSplit;->findMain(Ljava/util/ArrayList;)I

    move-result v14

    if-eqz v3, :cond_67

    if-ltz v14, :cond_67

    invoke-virtual {v0, v14}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Llio;

    iget-object v7, v6, Llio;->b:Lu1w;

    if-eqz v7, :cond_67

    iget-object v7, v7, Lu1w;->x:Landroid/view/View;

    if-eqz v7, :cond_67

    invoke-virtual {v7}, Landroid/view/View;->getVisibility()I

    move-result v8

    if-nez v8, :cond_67

    invoke-virtual {v7}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v8

    if-ne v8, v2, :cond_67

    invoke-virtual {v2}, Landroid/view/View;->getWidth()I

    move-result v5

    mul-int/lit8 v5, v5, 0x2

    div-int/lit8 v5, v5, 0x5

    invoke-virtual {v2}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v8

    invoke-virtual {v8}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v8

    iget v8, v8, Landroid/util/DisplayMetrics;->density:F

    const/high16 v9, 0x43d20000    # 420.0f

    mul-float/2addr v9, v8

    float-to-int v9, v9

    if-le v5, v9, :cond_52

    move v5, v9

    :cond_52
    add-int/lit8 v6, v14, 0x1

    if-lt v6, v1, :cond_58

    const/4 v4, 0x2

    goto :goto_67

    :cond_58
    invoke-virtual {v0, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Llio;

    iget-object v7, v7, Llio;->a:Ljava/lang/Class;

    invoke-static {v7}, Lcom/zing/zalo/zsplit/ZSplit;->isPane(Ljava/lang/Class;)Z

    move-result v8

    if-eqz v8, :cond_67

    const/4 v4, 0x1

    :cond_67
    :goto_67
    invoke-virtual {p0, v14}, Lcom/zing/zalo/zsplit/ZSplit;->duo(I)I

    move-result v3

    if-gez v3, :cond_6a

    const/4 v4, 0x0

    goto :goto_6e

    :cond_6a
    if-lez v3, :cond_6e

    move v5, v3

    :cond_6e
    :goto_6e
    const/4 v6, 0x0

    const/4 v7, 0x1

    :goto_70
    if-ge v6, v1, :cond_bd

    invoke-virtual {v0, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Llio;

    iget-object v9, v8, Llio;->b:Lu1w;

    if-eqz v9, :cond_ba

    iget-object v9, v9, Lu1w;->x:Landroid/view/View;

    if-eqz v9, :cond_ba

    iget-object v8, v8, Llio;->a:Ljava/lang/Class;

    const/4 v10, -0x1

    const/4 v11, 0x0

    if-eqz v4, :cond_97

    if-lt v6, v14, :cond_97

    if-ne v6, v14, :cond_8c

    move v10, v5

    goto :goto_97

    :cond_8c
    invoke-static {v8}, Lcom/zing/zalo/zsplit/ZSplit;->isPane(Ljava/lang/Class;)Z

    move-result v12

    if-nez v12, :cond_94

    const/4 v7, 0x0

    goto :goto_97

    :cond_94
    if-eqz v7, :cond_97

    move v11, v5

    :cond_97
    :goto_97
    invoke-static {v0, v6, v9, v8}, Lcom/zing/zalo/zsplit/ZGlass;->shouldSkipModal(Ljava/util/ArrayList;ILandroid/view/View;Ljava/lang/Class;)Z

    move-result v12

    if-nez v12, :cond_ba

    invoke-static {v0, v6, v9, v8, v11}, Lcom/zing/zalo/zsplit/ZSplit;->decoDuo(Ljava/util/ArrayList;ILandroid/view/View;Ljava/lang/Class;I)Z

    move-result v12

    if-nez v12, :cond_ba

    sget-object v12, Lcom/zing/zalo/zsplit/ZSplit;->sMod:Ljava/util/WeakHashMap;

    const/4 v13, -0x1

    if-ne v10, v13, :cond_b2

    if-nez v11, :cond_b2

    invoke-virtual {v12, v9}, Ljava/util/WeakHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v13

    invoke-static {v9, v10, v11}, Lcom/zing/zalo/zsplit/ZSplit;->apply(Landroid/view/View;II)V

    goto :goto_mainw

    :cond_b2
    sget-object v13, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v12, v9, v13}, Ljava/util/WeakHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    invoke-static {v9, v10, v11}, Lcom/zing/zalo/zsplit/ZSplit;->apply(Landroid/view/View;II)V

    :goto_mainw
    if-ne v6, v14, :cond_ba

    sget v12, Lcom/zing/zalo/zsplit/ZSplit;->sMainW:I

    if-eq v12, v10, :cond_ba

    sput v10, Lcom/zing/zalo/zsplit/ZSplit;->sMainW:I

    if-eqz v12, :cond_ba

    instance-of v12, v9, Landroid/view/ViewGroup;

    if-eqz v12, :cond_ba

    new-instance v12, Lcom/zing/zalo/zsplit/ZGlass$2;

    move-object v13, v9

    check-cast v13, Landroid/view/ViewGroup;

    invoke-direct {v12, v13}, Lcom/zing/zalo/zsplit/ZGlass$2;-><init>(Landroid/view/ViewGroup;)V

    const-wide/16 v10, 0x50

    invoke-virtual {v9, v12, v10, v11}, Landroid/view/View;->postDelayed(Ljava/lang/Runnable;J)Z

    :cond_ba
    :goto_ba
    add-int/lit8 v6, v6, 0x1

    goto :goto_70

    :cond_bd
    invoke-static {v0, v14, v2}, Lcom/zing/zalo/zsplit/ZSplit;->backdrop(Ljava/util/ArrayList;ILandroid/view/View;)V

    invoke-static {v0, v14, v2}, Lcom/zing/zalo/zsplit/ZSplit;->dockAll(Ljava/util/ArrayList;ILandroid/view/View;)V

    const/4 v6, 0x0

    const/4 v7, 0x2

    if-ne v4, v7, :cond_c8

    const/4 v6, 0x1

    :cond_c8
    invoke-virtual {p0, v6, v5}, Lcom/zing/zalo/zsplit/ZSplit;->updatePh(ZI)V

    invoke-static {v0, v2, v4, v14}, Lcom/zing/zalo/zsplit/ZSplit;->dlog(Ljava/util/ArrayList;Landroid/view/View;II)V

    const/4 v7, 0x1

    if-ne v4, v7, :cond_e1

    add-int/lit8 v6, v14, 0x1

    invoke-virtual {v0, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Llio;

    iget-object v6, v6, Llio;->b:Lu1w;

    if-eqz v6, :cond_e1

    iget-object v6, v6, Lu1w;->x:Landroid/view/View;

    if-eqz v6, :cond_e1

    invoke-static {v6}, Lcom/zing/zalo/zsplit/ZSplit;->diag(Landroid/view/View;)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_e1

    :catch_e1
    :cond_e1
    const/4 v0, 0x1

    return v0
.end method

.method post(Ljava/lang/Class;)V
    .locals 0

    return-void
.end method

.method updatePh(ZI)V
    .locals 6

    iget-object v0, p0, Lcom/zing/zalo/zsplit/ZSplit;->ph:Landroid/view/View;

    if-nez p1, :cond_12

    if-eqz v0, :cond_11

    invoke-virtual {v0}, Landroid/view/View;->getVisibility()I

    move-result v1

    const/16 v2, 0x8

    if-eq v1, v2, :cond_11

    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    :cond_11
    return-void

    :cond_12
    if-nez v0, :cond_63

    iget-object v1, p0, Lcom/zing/zalo/zsplit/ZSplit;->container:Landroid/view/View;

    instance-of v2, v1, Landroid/view/ViewGroup;

    if-eqz v2, :cond_11

    check-cast v1, Landroid/view/ViewGroup;

    new-instance v0, Landroid/widget/TextView;

    invoke-virtual {v1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-direct {v0, v2}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v2, ""

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/16 v2, 0x11

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setGravity(I)V

    const/high16 v2, 0x41800000

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setTextSize(F)V

    invoke-virtual {v1}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object v2

    iget v2, v2, Landroid/content/res/Configuration;->uiMode:I

    and-int/lit8 v2, v2, 0x30

    const/16 v3, 0x20

    if-ne v2, v3, :cond_4b

    const v2, -0xededee

    const v3, -0x655f5a

    goto :goto_51

    :cond_4b
    const v2, -0x1a150f

    const v3, -0x857a6c

    :goto_51
    invoke-virtual {v0, v2}, Landroid/view/View;->setBackgroundColor(I)V

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setTextColor(I)V

    new-instance v4, Landroid/view/ViewGroup$MarginLayoutParams;

    const/4 v5, -0x1

    invoke-direct {v4, v5, v5}, Landroid/view/ViewGroup$MarginLayoutParams;-><init>(II)V

    const/4 v5, 0x0

    invoke-virtual {v1, v0, v5, v4}, Landroid/view/ViewGroup;->addView(Landroid/view/View;ILandroid/view/ViewGroup$LayoutParams;)V

    iput-object v0, p0, Lcom/zing/zalo/zsplit/ZSplit;->ph:Landroid/view/View;

    :cond_63
    const/4 v1, -0x1

    invoke-static {v0, v1, p2}, Lcom/zing/zalo/zsplit/ZSplit;->apply(Landroid/view/View;II)V

    invoke-virtual {v0}, Landroid/view/View;->getVisibility()I

    move-result v1

    if-eqz v1, :cond_71

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    :cond_71
    return-void
.end method

