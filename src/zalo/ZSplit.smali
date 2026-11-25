.class public final Lcom/zing/zalo/zsplit/ZSplit;
.super Ljava/lang/Object;
# interfaces
.implements Landroid/view/ViewTreeObserver$OnPreDrawListener;
# static fields
.field static sContainer:Ljava/lang/ref/WeakReference;
.field static sDiagN:I

.field static sLast:Ljava/lang/String;

.field static sLay:Ljava/util/WeakHashMap;

.field static sBlur:Ljava/util/WeakHashMap;

.field static sScrim:Ljava/util/WeakHashMap;

.field static sPadT:I

.field static sIsList:Ljava/util/HashMap;

.field static sDock:Ljava/util/WeakHashMap;
.field static final sMod:Ljava/util/WeakHashMap;
.field static final sSeen:Ljava/util/HashSet;
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
    check-cast v2, Lcbo;
    iget-object v2, v2, Lcbo;->b:Lvrv;
    if-eqz v2, :cond_1a
    iget-object v2, v2, Lvrv;->x:Landroid/view/View;
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
    check-cast v3, Lcbo;
    iget-object v3, v3, Lcbo;->a:Ljava/lang/Class;
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
    check-cast v1, Lcbo;
    iget-object v1, v1, Lcbo;->a:Ljava/lang/Class;
    if-ne v1, v2, :cond_15
    return v0
    :cond_15
    add-int/lit8 v0, v0, -0x1
    goto :goto_8
    :cond_18
    const/4 v0, -0x1
    return v0
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
.method public static onShow(Lcom/zing/zalo/zview/b;ILjava/lang/Class;Landroid/os/Bundle;)Landroid/os/Bundle;
    .locals 9
    const-class v0, Lcom/zing/zalo/ui/maintab/MainTabView;
    if-ne p2, v0, :cond_8
    invoke-static {p0}, Lcom/zing/zalo/zsplit/ZRetry;->schedule(Lcom/zing/zalo/zview/b;)V
    return-object p3
    :cond_8
    const-class v0, Lcom/zing/zalo/ui/chat/ChatView;
    if-eq p2, v0, :cond_d
    return-object p3
    :cond_d
    iget-object v1, p0, Lcom/zing/zalo/zview/b;->d:Ljava/util/ArrayList;
    if-nez v1, :cond_12
    return-object p3
    :cond_12
    :try_start_12
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V
    const-string v8, "ZSplit: "
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-static {v1}, Lcom/zing/zalo/zsplit/ZSplit;->desc(Ljava/util/ArrayList;)Ljava/lang/String;
    move-result-object v8
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I
    move-result v2
    invoke-static {v1}, Lcom/zing/zalo/zsplit/ZSplit;->findMain(Ljava/util/ArrayList;)I
    move-result v3
    const-string v8, " | main="
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    if-ltz v3, :cond_a0
    invoke-virtual {v1, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v4
    check-cast v4, Lcbo;
    iget-object v4, v4, Lcbo;->b:Lvrv;
    if-eqz v4, :cond_a0
    iget-object v4, v4, Lvrv;->x:Landroid/view/View;
    if-eqz v4, :cond_a0
    invoke-virtual {v4}, Landroid/view/View;->getParent()Landroid/view/ViewParent;
    move-result-object v4
    instance-of v5, v4, Landroid/view/View;
    if-eqz v5, :cond_a0
    check-cast v4, Landroid/view/View;
    invoke-static {p0, v4}, Lcom/zing/zalo/zsplit/ZSplit;->install(Lcom/zing/zalo/zview/b;Landroid/view/View;)V
    invoke-static {v4}, Lcom/zing/zalo/zsplit/ZSplit;->isWide(Landroid/view/View;)Z
    move-result v5
    const-string v8, " wide="
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    const-string v8, " w="
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Landroid/view/View;->getWidth()I
    move-result v6
    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v8, "x"
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Landroid/view/View;->getHeight()I
    move-result v6
    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    if-eqz v5, :cond_a0
    if-nez v3, :cond_a0
    const/4 v5, 0x1
    if-le v2, v5, :cond_a0
    add-int/lit8 v5, v2, -0x1
    invoke-virtual {v1, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v5
    check-cast v5, Lcbo;
    iget-object v5, v5, Lcbo;->a:Ljava/lang/Class;
    if-ne v5, v0, :cond_a0
    if-nez p3, :cond_8f
    new-instance v6, Landroid/os/Bundle;
    invoke-direct {v6}, Landroid/os/Bundle;-><init>()V
    move-object p3, v6
    :cond_8f
    const-string v5, "SHOW_WITH_FLAGS"
    invoke-virtual {p3, v5}, Landroid/os/BaseBundle;->getInt(Ljava/lang/String;)I
    move-result v6
    const/high16 v4, 0x700000
    or-int/2addr v6, v4
    invoke-virtual {p3, v5, v6}, Landroid/os/BaseBundle;->putInt(Ljava/lang/String;I)V
    const-string v8, " replace"
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :cond_a0
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v8
    invoke-static {v1, v8}, Lcom/zing/zalo/zsplit/ZSplit;->toast(Ljava/util/ArrayList;Ljava/lang/String;)V
    :try_end_12
    .catch Ljava/lang/Throwable; {:try_start_12 .. :try_end_12} :catch_a8
    return-object p3
    :catch_a8
    move-exception v8
    invoke-virtual {v8}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v8
    invoke-static {v1, v8}, Lcom/zing/zalo/zsplit/ZSplit;->toast(Ljava/util/ArrayList;Ljava/lang/String;)V
    return-object p3
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
    check-cast v2, Lcbo;
    iget-object v2, v2, Lcbo;->b:Lvrv;
    if-eqz v2, :cond_2a
    iget-object v2, v2, Lvrv;->x:Landroid/view/View;
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
# virtual methods
.method public onPreDraw()Z
    .locals 15
    :try_start_0
    iget-object v0, p0, Lcom/zing/zalo/zsplit/ZSplit;->mgr:Lcom/zing/zalo/zview/b;
    iget-object v0, v0, Lcom/zing/zalo/zview/b;->d:Ljava/util/ArrayList;
    if-eqz v0, :cond_c1
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
    if-eqz v3, :cond_60
    if-ltz v14, :cond_60
    invoke-virtual {v0, v14}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v6
    check-cast v6, Lcbo;
    iget-object v7, v6, Lcbo;->b:Lvrv;
    if-eqz v7, :cond_60
    iget-object v7, v7, Lvrv;->x:Landroid/view/View;
    if-eqz v7, :cond_60
    invoke-virtual {v7}, Landroid/view/View;->getVisibility()I
    move-result v8
    if-nez v8, :cond_60
    invoke-virtual {v7}, Landroid/view/View;->getParent()Landroid/view/ViewParent;
    move-result-object v8
    if-ne v8, v2, :cond_60
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
    if-le v5, v9, :cond_4d
    move v5, v9
    :cond_4d
    add-int/lit8 v6, v14, 0x1
    if-lt v6, v1, :cond_53
    const/4 v4, 0x2
    goto :goto_60
    :cond_53
    invoke-virtual {v0, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v7
    check-cast v7, Lcbo;
    iget-object v7, v7, Lcbo;->a:Ljava/lang/Class;
    invoke-static {v7}, Lcom/zing/zalo/zsplit/ZSplit;->isPane(Ljava/lang/Class;)Z
    move-result v8
    if-eqz v8, :cond_60
    const/4 v4, 0x1
    :cond_60
    :goto_60
    invoke-static {v0, v2, v4, v14}, Lcom/zing/zalo/zsplit/ZSplit;->dlog(Ljava/util/ArrayList;Landroid/view/View;II)V
    const/4 v6, 0x0
    const/4 v7, 0x1
    :goto_62
    if-ge v6, v1, :cond_a3
    invoke-virtual {v0, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v8
    check-cast v8, Lcbo;
    iget-object v9, v8, Lcbo;->b:Lvrv;
    if-eqz v9, :cond_a0
    iget-object v9, v9, Lvrv;->x:Landroid/view/View;
    if-eqz v9, :cond_a0
    iget-object v8, v8, Lcbo;->a:Ljava/lang/Class;
    const/4 v10, -0x1
    const/4 v11, 0x0
    if-eqz v4, :cond_87
    if-lt v6, v14, :cond_87
    if-ne v6, v14, :cond_7e
    move v10, v5
    goto :goto_87
    :cond_7e
    invoke-static {v8}, Lcom/zing/zalo/zsplit/ZSplit;->isPane(Ljava/lang/Class;)Z
    move-result v12
    if-nez v12, :cond_84
    const/4 v7, 0x0
    goto :goto_87
    :cond_84
    if-eqz v7, :cond_87
    move v11, v5
    :cond_87
    :goto_87
    invoke-static {v9, v8, v11, v2}, Lcom/zing/zalo/zsplit/ZSplit;->deco(Landroid/view/View;Ljava/lang/Class;ILandroid/view/View;)Z
    move-result v12
    if-nez v12, :cond_a0
    sget-object v12, Lcom/zing/zalo/zsplit/ZSplit;->sMod:Ljava/util/WeakHashMap;
    const/4 v13, -0x1
    if-ne v10, v13, :cond_98
    if-nez v11, :cond_98
    invoke-virtual {v12, v9}, Ljava/util/WeakHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v13
    if-eqz v13, :cond_a0
    invoke-static {v9, v10, v11}, Lcom/zing/zalo/zsplit/ZSplit;->apply(Landroid/view/View;II)V
    goto :goto_a0
    :cond_98
    sget-object v13, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;
    invoke-virtual {v12, v9, v13}, Ljava/util/WeakHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    invoke-static {v9, v10, v11}, Lcom/zing/zalo/zsplit/ZSplit;->apply(Landroid/view/View;II)V
    :cond_a0
    :goto_a0
    add-int/lit8 v6, v6, 0x1
    goto :goto_62
    :cond_a3
    invoke-static {v0, v14, v2}, Lcom/zing/zalo/zsplit/ZSplit;->backdrop(Ljava/util/ArrayList;ILandroid/view/View;)V
    invoke-static {v0, v14, v2}, Lcom/zing/zalo/zsplit/ZSplit;->dockAll(Ljava/util/ArrayList;ILandroid/view/View;)V
    const/4 v6, 0x0
    const/4 v7, 0x2
    if-ne v4, v7, :cond_a8
    const/4 v6, 0x1
    :cond_a8
    invoke-virtual {p0, v6, v5}, Lcom/zing/zalo/zsplit/ZSplit;->updatePh(ZI)V
    const/4 v7, 0x1
    if-ne v4, v7, :cond_c1
    add-int/lit8 v6, v14, 0x1
    invoke-virtual {v0, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v6
    check-cast v6, Lcbo;
    iget-object v6, v6, Lcbo;->b:Lvrv;
    if-eqz v6, :cond_c1
    iget-object v6, v6, Lvrv;->x:Landroid/view/View;
    if-eqz v6, :cond_c1
    invoke-static {v6}, Lcom/zing/zalo/zsplit/ZSplit;->diag(Landroid/view/View;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_c1
    :catch_c1
    :cond_c1
    const/4 v0, 0x1
    return v0
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
    const-string v2, "Ch\u1ecdn m\u1ed9t cu\u1ed9c tr\u00f2 chuy\u1ec7n"
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

.method public static isPane(Ljava/lang/Class;)Z
    .locals 5
    if-nez p0, :c
    const/4 v0, 0x0
    return v0
    :c
    const-class v0, Lcom/zing/zalo/ui/chat/ChatView;
    if-ne p0, v0, :n
    const/4 v0, 0x1
    return v0
    :n
    const-class v0, Lprv;
    invoke-virtual {v0, p0}, Ljava/lang/Class;->isAssignableFrom(Ljava/lang/Class;)Z
    move-result v0
    if-nez v0, :no
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
    :loop
    if-ge v3, v2, :yes
    aget-object v4, v1, v3
    invoke-virtual {v0, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v4
    if-nez v4, :no
    add-int/lit8 v3, v3, 0x1
    goto :loop
    :yes
    const/4 v0, 0x1
    return v0
    :no
    const/4 v0, 0x0
    return v0
.end method

.method static keepMain(Ljava/util/ArrayList;Landroid/view/View;)V
    .locals 7
    :try_start
    invoke-static {p1}, Lcom/zing/zalo/zsplit/ZSplit;->isWide(Landroid/view/View;)Z
    move-result v0
    if-eqz v0, :out
    invoke-static {p0}, Lcom/zing/zalo/zsplit/ZSplit;->findMain(Ljava/util/ArrayList;)I
    move-result v1
    if-ltz v1, :out
    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I
    move-result v2
    add-int/lit8 v3, v1, 0x1
    if-ge v3, v2, :out
    :loop
    if-ge v3, v2, :ok
    invoke-virtual {p0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v4
    check-cast v4, Lcbo;
    iget-object v4, v4, Lcbo;->a:Ljava/lang/Class;
    invoke-static {v4}, Lcom/zing/zalo/zsplit/ZSplit;->isPane(Ljava/lang/Class;)Z
    move-result v4
    if-eqz v4, :out
    add-int/lit8 v3, v3, 0x1
    goto :loop
    :ok
    invoke-virtual {p0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v4
    check-cast v4, Lcbo;
    iget-object v4, v4, Lcbo;->b:Lvrv;
    if-eqz v4, :out
    iget-object v4, v4, Lvrv;->x:Landroid/view/View;
    if-eqz v4, :out
    invoke-virtual {v4}, Landroid/view/View;->getParent()Landroid/view/ViewParent;
    move-result-object v5
    if-ne v5, p1, :out
    invoke-virtual {v4}, Landroid/view/View;->getVisibility()I
    move-result v5
    if-eqz v5, :chats
    const/4 v5, 0x0
    invoke-virtual {v4, v5}, Landroid/view/View;->setVisibility(I)V
    :chats
    invoke-static {p0, p1, v1}, Lcom/zing/zalo/zsplit/ZSplit;->showChats(Ljava/util/ArrayList;Landroid/view/View;I)V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :out
    :out
    return-void
.end method

.method static dlog(Ljava/util/ArrayList;Landroid/view/View;II)V
    .locals 8
    :try_start
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
    :loop
    if-ge v3, v2, :done
    invoke-virtual {p0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v4
    check-cast v4, Lcbo;
    const-string v1, " "
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    iget-object v5, v4, Lcbo;->a:Ljava/lang/Class;
    if-eqz v5, :nocls
    invoke-virtual {v5}, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object v6
    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v1, "/pane="
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-static {v5}, Lcom/zing/zalo/zsplit/ZSplit;->isPane(Ljava/lang/Class;)Z
    move-result v6
    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    :nocls
    iget-object v5, v4, Lcbo;->b:Lvrv;
    if-eqz v5, :nx
    iget-object v5, v5, Lvrv;->x:Landroid/view/View;
    if-eqz v5, :nx
    const-string v1, "/vis="
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Landroid/view/View;->getVisibility()I
    move-result v6
    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v1, "/par="
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Landroid/view/View;->getParent()Landroid/view/ViewParent;
    move-result-object v6
    if-ne v6, p1, :other
    const-string v1, "C"
    goto :pp
    :other
    const-string v1, "X"
    :pp
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :nx
    add-int/lit8 v3, v3, 0x1
    goto :loop
    :done
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    sget-object v1, Lcom/zing/zalo/zsplit/ZSplit;->sLast:Ljava/lang/String;
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :out
    sput-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sLast:Ljava/lang/String;
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v1
    const/4 v2, 0x0
    invoke-virtual {v1, v2}, Landroid/content/Context;->getExternalFilesDir(Ljava/lang/String;)Ljava/io/File;
    move-result-object v1
    if-eqz v1, :out
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
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :out
    :out
    return-void
.end method

.method static isMainHost(Landroid/view/ViewGroup;Landroid/view/View;)Z
    .locals 3
    :try_start
    invoke-static {p0}, Lcom/zing/zalo/zsplit/ZSplit;->isWide(Landroid/view/View;)Z
    move-result v0
    if-eqz v0, :no
    instance-of v0, p1, Landroid/view/ViewGroup;
    if-eqz v0, :no
    move-object v0, p1
    check-cast v0, Landroid/view/ViewGroup;
    invoke-virtual {v0}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v1
    if-lez v1, :no
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object v0
    const-string v2, "MainTabFrameLayout"
    invoke-virtual {v0, v2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v2
    if-nez v2, :yes
    const-string v2, "ZaloDrawerLayout"
    invoke-virtual {v0, v2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v0
    return v0
    :yes
    const/4 v0, 0x1
    return v0
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :no
    :no
    const/4 v0, 0x0
    return v0
.end method

.method public static zs_removeView(Landroid/view/ViewGroup;Landroid/view/View;)V
    .locals 1
    invoke-static {p0, p1}, Lcom/zing/zalo/zsplit/ZSplit;->isMainHost(Landroid/view/ViewGroup;Landroid/view/View;)Z
    move-result v0
    if-eqz v0, :rm
    return-void
    :rm
    invoke-virtual {p0, p1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V
    return-void
.end method

.method public static zs_addView(Landroid/view/ViewGroup;Landroid/view/View;)V
    .locals 1
    invoke-virtual {p1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;
    move-result-object v0
    if-ne v0, p0, :a
    return-void
    :a
    invoke-virtual {p0, p1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V
    return-void
.end method

.method public static zs_addView(Landroid/view/ViewGroup;Landroid/view/View;I)V
    .locals 1
    invoke-virtual {p1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;
    move-result-object v0
    if-ne v0, p0, :a
    return-void
    :a
    invoke-virtual {p0, p1, p2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;I)V
    return-void
.end method

.method public static zs_addView(Landroid/view/ViewGroup;Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    .locals 1
    invoke-virtual {p1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;
    move-result-object v0
    if-ne v0, p0, :a
    invoke-virtual {p1, p2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    return-void
    :a
    invoke-virtual {p0, p1, p2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    return-void
.end method

.method static map(I)Ljava/util/WeakHashMap;
    .locals 1
    if-nez p0, :b
    sget-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sLay:Ljava/util/WeakHashMap;
    if-nez v0, :r
    new-instance v0, Ljava/util/WeakHashMap;
    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V
    sput-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sLay:Ljava/util/WeakHashMap;
    :r
    return-object v0
    :b
    sget-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sBlur:Ljava/util/WeakHashMap;
    if-nez v0, :r2
    new-instance v0, Ljava/util/WeakHashMap;
    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V
    sput-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sBlur:Ljava/util/WeakHashMap;
    :r2
    return-object v0
.end method

.method static deco(Landroid/view/View;Ljava/lang/Class;ILandroid/view/View;)Z
    .locals 2
    :try_start
    if-lez p2, :un
    const-class v0, Lcom/zing/zalo/ui/chat/ChatView;
    if-eq p1, v0, :un
    invoke-static {p0, p3}, Lcom/zing/zalo/zsplit/ZSplit;->layer(Landroid/view/View;Landroid/view/View;)V
    const/4 v0, 0x1
    return v0
    :un
    invoke-static {p0}, Lcom/zing/zalo/zsplit/ZSplit;->unlayer(Landroid/view/View;)V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :e
    :e
    const/4 v0, 0x0
    return v0
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
    if-lez v1, :out
    if-lez v2, :out
    int-to-float v3, v1
    const v4, 0x3f28f5c3
    mul-float/2addr v3, v4
    float-to-int v3, v3
    const/high16 v4, 0x44160000
    mul-float/2addr v4, v0
    float-to-int v4, v4
    if-le v3, v4, :w
    move v3, v4
    :w
    int-to-float v4, v2
    const v5, 0x3f63d70a
    mul-float/2addr v4, v5
    float-to-int v4, v4
    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    move-result-object v5
    instance-of v6, v5, Landroid/widget/FrameLayout$LayoutParams;
    if-eqz v6, :out
    check-cast v5, Landroid/widget/FrameLayout$LayoutParams;
    iget v6, v5, Landroid/widget/FrameLayout$LayoutParams;->width:I
    if-ne v6, v3, :set
    iget v6, v5, Landroid/widget/FrameLayout$LayoutParams;->height:I
    if-ne v6, v4, :set
    iget v6, v5, Landroid/widget/FrameLayout$LayoutParams;->gravity:I
    const/16 v7, 0x11
    if-ne v6, v7, :set
    iget v6, v5, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I
    if-eqz v6, :deco
    :set
    iput v3, v5, Landroid/widget/FrameLayout$LayoutParams;->width:I
    iput v4, v5, Landroid/widget/FrameLayout$LayoutParams;->height:I
    const/16 v7, 0x11
    iput v7, v5, Landroid/widget/FrameLayout$LayoutParams;->gravity:I
    const/4 v7, 0x0
    iput v7, v5, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I
    invoke-virtual {p0, v5}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    :deco
    const/4 v6, 0x0
    invoke-static {v6}, Lcom/zing/zalo/zsplit/ZSplit;->map(I)Ljava/util/WeakHashMap;
    move-result-object v6
    invoke-virtual {v6, p0}, Ljava/util/WeakHashMap;->containsKey(Ljava/lang/Object;)Z
    move-result v7
    if-nez v7, :out
    sget-object v7, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;
    invoke-virtual {v6, p0, v7}, Ljava/util/WeakHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    const/high16 v7, 0x41e00000
    mul-float/2addr v7, v0
    new-instance v8, Lcom/zing/zalo/zsplit/ZOutline;
    invoke-direct {v8, v7}, Lcom/zing/zalo/zsplit/ZOutline;-><init>(F)V
    invoke-virtual {p0, v8}, Landroid/view/View;->setOutlineProvider(Landroid/view/ViewOutlineProvider;)V
    const/4 v8, 0x1
    invoke-virtual {p0, v8}, Landroid/view/View;->setClipToOutline(Z)V
    const/high16 v8, 0x41c00000
    mul-float/2addr v8, v0
    invoke-virtual {p0, v8}, Landroid/view/View;->setElevation(F)V
    new-instance v8, Landroid/graphics/drawable/GradientDrawable;
    invoke-direct {v8}, Landroid/graphics/drawable/GradientDrawable;-><init>()V
    invoke-virtual {v8, v7}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V
    const/4 v1, 0x0
    invoke-virtual {v8, v1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V
    const/high16 v1, 0x3fc00000
    mul-float/2addr v1, v0
    float-to-int v1, v1
    const v2, 0x73ffffff
    invoke-virtual {v8, v1, v2}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V
    invoke-virtual {p0, v8}, Landroid/view/View;->setForeground(Landroid/graphics/drawable/Drawable;)V
    :out
    return-void
.end method

.method static unlayer(Landroid/view/View;)V
    .locals 3
    const/4 v0, 0x0
    invoke-static {v0}, Lcom/zing/zalo/zsplit/ZSplit;->map(I)Ljava/util/WeakHashMap;
    move-result-object v0
    invoke-virtual {v0, p0}, Ljava/util/WeakHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
    if-eqz v0, :out
    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    move-result-object v0
    instance-of v1, v0, Landroid/widget/FrameLayout$LayoutParams;
    if-eqz v1, :fx
    check-cast v0, Landroid/widget/FrameLayout$LayoutParams;
    const/4 v1, -0x1
    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->width:I
    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->height:I
    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->gravity:I
    const/4 v1, 0x0
    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I
    invoke-virtual {p0, v0}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    :fx
    sget-object v0, Landroid/view/ViewOutlineProvider;->BACKGROUND:Landroid/view/ViewOutlineProvider;
    invoke-virtual {p0, v0}, Landroid/view/View;->setOutlineProvider(Landroid/view/ViewOutlineProvider;)V
    const/4 v0, 0x0
    invoke-virtual {p0, v0}, Landroid/view/View;->setClipToOutline(Z)V
    const/4 v1, 0x0
    invoke-virtual {p0, v1}, Landroid/view/View;->setElevation(F)V
    const/4 v1, 0x0
    invoke-virtual {p0, v1}, Landroid/view/View;->setForeground(Landroid/graphics/drawable/Drawable;)V
    :out
    return-void
.end method

.method static backdrop(Ljava/util/ArrayList;ILandroid/view/View;)V
    .locals 9
    :try_start
    const/4 v0, 0x0
    invoke-static {v0}, Lcom/zing/zalo/zsplit/ZSplit;->map(I)Ljava/util/WeakHashMap;
    move-result-object v1
    const/4 v0, 0x1
    invoke-static {v0}, Lcom/zing/zalo/zsplit/ZSplit;->map(I)Ljava/util/WeakHashMap;
    move-result-object v2
    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I
    move-result v3
    const/4 v4, 0x0
    if-lez v3, :p2
    add-int/lit8 v5, v3, -0x1
    invoke-virtual {p0, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v6
    check-cast v6, Lcbo;
    iget-object v6, v6, Lcbo;->b:Lvrv;
    if-eqz v6, :p2
    iget-object v6, v6, Lvrv;->x:Landroid/view/View;
    if-eqz v6, :p2
    invoke-virtual {v1, v6}, Ljava/util/WeakHashMap;->containsKey(Ljava/lang/Object;)Z
    move-result v7
    if-eqz v7, :p2
    invoke-virtual {v6}, Landroid/view/View;->getVisibility()I
    move-result v7
    if-nez v7, :p2
    const/4 v4, 0x1
    :p2
    const/4 v5, 0x0
    :l2
    if-ge v5, v3, :sc
    invoke-virtual {p0, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v6
    check-cast v6, Lcbo;
    iget-object v7, v6, Lcbo;->a:Ljava/lang/Class;
    iget-object v6, v6, Lcbo;->b:Lvrv;
    if-eqz v6, :n2
    iget-object v6, v6, Lvrv;->x:Landroid/view/View;
    if-eqz v6, :n2
    const/4 v8, 0x0
    if-eqz v4, :dec
    invoke-virtual {v1, v6}, Ljava/util/WeakHashMap;->containsKey(Ljava/lang/Object;)Z
    move-result v0
    if-nez v0, :dec
    if-eq v5, p1, :yes
    const-class v0, Lcom/zing/zalo/ui/chat/ChatView;
    if-ne v7, v0, :dec
    :yes
    const/4 v8, 0x1
    :dec
    if-eqz v8, :clr
    invoke-virtual {v2, v6}, Ljava/util/WeakHashMap;->containsKey(Ljava/lang/Object;)Z
    move-result v0
    if-nez v0, :n2
    sget-object v0, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;
    invoke-virtual {v2, v6, v0}, Ljava/util/WeakHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    new-instance v0, Landroid/graphics/drawable/ColorDrawable;
    const v7, 0x33000000
    invoke-direct {v0, v7}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V
    invoke-virtual {v6, v0}, Landroid/view/View;->setForeground(Landroid/graphics/drawable/Drawable;)V
    invoke-static {v6}, Lcom/zing/zalo/zsplit/ZSplit;->blur(Landroid/view/View;)V
    goto :n2
    :clr
    invoke-virtual {v2, v6}, Ljava/util/WeakHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
    if-eqz v0, :n2
    const/4 v0, 0x0
    invoke-virtual {v6, v0}, Landroid/view/View;->setForeground(Landroid/graphics/drawable/Drawable;)V
    invoke-static {v6}, Lcom/zing/zalo/zsplit/ZSplit;->unblur(Landroid/view/View;)V
    :n2
    add-int/lit8 v5, v5, 0x1
    goto :l2
    :sc
    invoke-static {p2, v4}, Lcom/zing/zalo/zsplit/ZSplit;->scrim(Landroid/view/View;Z)V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :out
    :out
    return-void
.end method

.method static blur(Landroid/view/View;)V
    .locals 3
    :try_start
    const/high16 v0, 0x42200000
    sget-object v1, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;
    invoke-static {v0, v0, v1}, Landroid/graphics/RenderEffect;->createBlurEffect(FFLandroid/graphics/Shader$TileMode;)Landroid/graphics/RenderEffect;
    move-result-object v2
    invoke-virtual {p0, v2}, Landroid/view/View;->setRenderEffect(Landroid/graphics/RenderEffect;)V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :e
    :e
    return-void
.end method

.method static unblur(Landroid/view/View;)V
    .locals 1
    :try_start
    const/4 v0, 0x0
    invoke-virtual {p0, v0}, Landroid/view/View;->setRenderEffect(Landroid/graphics/RenderEffect;)V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :e
    :e
    return-void
.end method

.method static showChats(Ljava/util/ArrayList;Landroid/view/View;I)V
    .locals 6
    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I
    move-result v0
    add-int/lit8 v1, v0, -0x1
    invoke-virtual {p0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Lcbo;
    iget-object v1, v1, Lcbo;->a:Ljava/lang/Class;
    const-class v2, Lcom/zing/zalo/ui/chat/ChatView;
    if-ne v1, v2, :go
    return-void
    :go
    add-int/lit8 v3, p2, 0x1
    :loop
    if-ge v3, v0, :out
    invoke-virtual {p0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v4
    check-cast v4, Lcbo;
    iget-object v5, v4, Lcbo;->a:Ljava/lang/Class;
    if-ne v5, v2, :nx
    iget-object v4, v4, Lcbo;->b:Lvrv;
    if-eqz v4, :nx
    iget-object v4, v4, Lvrv;->x:Landroid/view/View;
    if-eqz v4, :nx
    invoke-virtual {v4}, Landroid/view/View;->getParent()Landroid/view/ViewParent;
    move-result-object v5
    if-ne v5, p1, :nx
    invoke-virtual {v4}, Landroid/view/View;->getVisibility()I
    move-result v5
    if-eqz v5, :nx
    const/4 v5, 0x0
    invoke-virtual {v4, v5}, Landroid/view/View;->setVisibility(I)V
    :nx
    add-int/lit8 v3, v3, 0x1
    goto :loop
    :out
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
    if-eqz v0, :n
    invoke-virtual {p0, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v0
    return-object v0
    :n
    const/4 v0, 0x0
    return-object v0
.end method



.method static clearKids(Landroid/view/View;)V
    .locals 4
    instance-of v0, p0, Landroid/view/ViewGroup;
    if-eqz v0, :out
    check-cast p0, Landroid/view/ViewGroup;
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v0
    const/4 v1, 0x0
    :loop
    if-ge v1, v0, :out
    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v2
    const/4 v3, 0x0
    invoke-virtual {v2, v3}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    add-int/lit8 v1, v1, 0x1
    goto :loop
    :out
    return-void
.end method

.method static scrim(Landroid/view/View;Z)V
    .locals 5
    :try_start
    instance-of v0, p0, Landroid/widget/FrameLayout;
    if-eqz v0, :out
    sget-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sScrim:Ljava/util/WeakHashMap;
    if-nez v0, :h
    new-instance v0, Ljava/util/WeakHashMap;
    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V
    sput-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sScrim:Ljava/util/WeakHashMap;
    :h
    invoke-virtual {v0, p0}, Ljava/util/WeakHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Landroid/view/View;
    if-eqz v1, :create
    invoke-virtual {v1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;
    move-result-object v2
    if-ne v2, p0, :create
    goto :set
    :create
    if-nez p1, :mk
    return-void
    :mk
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
    :set
    const/16 v2, 0x8
    if-eqz p1, :vis
    const/4 v2, 0x0
    :vis
    invoke-virtual {v1}, Landroid/view/View;->getVisibility()I
    move-result v3
    if-eq v3, v2, :out
    invoke-virtual {v1, v2}, Landroid/view/View;->setVisibility(I)V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :out
    :out
    return-void
.end method

.method static dockAll(Ljava/util/ArrayList;ILandroid/view/View;)V
    .locals 2
    :try_start
    if-ltz p1, :out
    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Lcbo;
    iget-object v0, v0, Lcbo;->b:Lvrv;
    if-eqz v0, :out
    iget-object v0, v0, Lvrv;->x:Landroid/view/View;
    if-eqz v0, :out
    const/4 v1, 0x1
    invoke-static {v0, v1}, Lcom/zing/zalo/zsplit/ZSplit;->dock(Landroid/view/View;Z)V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :out
    :out
    return-void
.end method

.method static dock(Landroid/view/View;Z)V
    .locals 12
    const-string v0, "sliding_tabs"
    invoke-static {p0, v0}, Lcom/zing/zalo/zsplit/ZSplit;->idOf(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;
    move-result-object v0
    if-nez v0, :a
    return-void
    :a
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
    if-nez v4, :have
    # first setup
    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    move-result-object v4
    instance-of v5, v4, Landroid/view/ViewGroup$MarginLayoutParams;
    if-eqz v5, :nolp
    check-cast v4, Landroid/view/ViewGroup$MarginLayoutParams;
    const/high16 v5, 0x41600000
    mul-float/2addr v5, v2
    float-to-int v5, v5
    iput v5, v4, Landroid/view/ViewGroup$MarginLayoutParams;->leftMargin:I
    iput v5, v4, Landroid/view/ViewGroup$MarginLayoutParams;->rightMargin:I
    iput v5, v4, Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I
    invoke-virtual {v0, v4}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    :nolp
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
    if-eqz v6, :ncp
    check-cast v5, Landroid/view/ViewGroup;
    invoke-virtual {v5, v4}, Landroid/view/ViewGroup;->setClipChildren(Z)V
    :ncp
    const/high16 v4, 0x41400000
    mul-float/2addr v4, v2
    invoke-virtual {v0, v4}, Landroid/view/View;->setElevation(F)V
    :have
    check-cast v3, Lcom/zing/zalo/zsplit/ZGlass;
    # per tick: clear kid backgrounds, hide RevealView, attach drag listeners
    instance-of v4, v0, Landroid/view/ViewGroup;
    if-eqz v4, :tk
    move-object v4, v0
    check-cast v4, Landroid/view/ViewGroup;
    invoke-virtual {v4}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v5
    const/4 v6, 0x0
    :kl
    if-ge v6, v5, :kdone
    invoke-virtual {v4, v6}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v7
    invoke-virtual {v7}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;
    move-result-object v8
    if-eqz v8, :nb
    const/4 v8, 0x0
    invoke-virtual {v7, v8}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    :nb
    invoke-virtual {v7}, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v8
    invoke-virtual {v8}, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object v8
    const-string v9, "RevealView"
    invoke-virtual {v8, v9}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v8
    if-eqz v8, :nr
    invoke-virtual {v7}, Landroid/view/View;->getVisibility()I
    move-result v8
    if-nez v8, :nr
    const/4 v8, 0x4
    invoke-virtual {v7, v8}, Landroid/view/View;->setVisibility(I)V
    :nr
    add-int/lit8 v6, v6, 0x1
    goto :kl
    :kdone
    invoke-virtual {v3}, Lcom/zing/zalo/zsplit/ZGlass;->tabs()Landroid/view/ViewGroup;
    move-result-object v4
    if-eqz v4, :tk
    invoke-virtual {v4}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v5
    const/4 v6, 0x0
    :tl
    if-ge v6, v5, :tk
    invoke-virtual {v4, v6}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v7
    invoke-virtual {v7}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;
    move-result-object v8
    if-eqz v8, :nbg
    const/4 v8, 0x0
    invoke-virtual {v7, v8}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    :nbg
    invoke-virtual {v7}, Landroid/view/View;->getForeground()Landroid/graphics/drawable/Drawable;
    move-result-object v8
    if-eqz v8, :nfg
    const/4 v8, 0x0
    invoke-virtual {v7, v8}, Landroid/view/View;->setForeground(Landroid/graphics/drawable/Drawable;)V
    :nfg
    invoke-static {v7}, Lcom/zing/zalo/zsplit/ZSplit;->noRipple(Landroid/view/View;)V
    sget-object v8, Lcom/zing/zalo/zsplit/ZSplit;->sDock:Ljava/util/WeakHashMap;
    if-nez v8, :dm
    new-instance v8, Ljava/util/WeakHashMap;
    invoke-direct {v8}, Ljava/util/WeakHashMap;-><init>()V
    sput-object v8, Lcom/zing/zalo/zsplit/ZSplit;->sDock:Ljava/util/WeakHashMap;
    :dm
    invoke-virtual {v8, v7}, Ljava/util/WeakHashMap;->containsKey(Ljava/lang/Object;)Z
    move-result v9
    if-nez v9, :tn
    new-instance v9, Lcom/zing/zalo/zsplit/ZDrag;
    invoke-direct {v9, v3}, Lcom/zing/zalo/zsplit/ZDrag;-><init>(Lcom/zing/zalo/zsplit/ZGlass;)V
    invoke-virtual {v7, v9}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V
    invoke-virtual {v7}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;
    invoke-virtual {v8, v7, v9}, Ljava/util/WeakHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :tn
    add-int/lit8 v6, v6, 0x1
    goto :tl
    :tk
    invoke-virtual {v3}, Lcom/zing/zalo/zsplit/ZGlass;->tick()V
    # extend pager under dock via MainTabFrameLayout.setBottomSpacing
    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;
    move-result-object v4
    instance-of v5, v4, Lcom/zing/zalo/uicontrol/MainTabFrameLayout;
    if-eqz v5, :pad
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
    if-eqz v6, :pad
    invoke-virtual {v5, v6}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I
    move-result v6
    invoke-virtual {v4}, Lcom/zing/zalo/uicontrol/MainTabFrameLayout;->getBottomSpacing()I
    move-result v7
    if-ltz v7, :pad
    if-ge v7, v6, :pad
    sub-int/2addr v7, v6
    invoke-virtual {v4, v7}, Lcom/zing/zalo/uicontrol/MainTabFrameLayout;->setBottomSpacing(I)V
    :pad
    sget v4, Lcom/zing/zalo/zsplit/ZSplit;->sPadT:I
    add-int/lit8 v4, v4, 0x1
    sput v4, Lcom/zing/zalo/zsplit/ZSplit;->sPadT:I
    rem-int/lit8 v4, v4, 0xf
    if-nez v4, :out
    if-eqz v1, :out
    invoke-virtual {v0}, Landroid/view/View;->getHeight()I
    move-result v4
    if-lez v4, :out
    const/high16 v5, 0x41a00000
    mul-float/2addr v5, v2
    float-to-int v5, v5
    add-int/2addr v4, v5
    invoke-virtual {v1}, Landroid/view/View;->getHeight()I
    move-result v5
    div-int/lit8 v5, v5, 0x2
    const/4 v6, 0x0
    invoke-static {v1, v4, v5, v6}, Lcom/zing/zalo/zsplit/ZSplit;->padLists(Landroid/view/View;III)V
    :out
    return-void
.end method

.method static isList(Ljava/lang/Class;)Z
    .locals 4
    sget-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sIsList:Ljava/util/HashMap;
    if-nez v0, :h
    new-instance v0, Ljava/util/HashMap;
    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V
    sput-object v0, Lcom/zing/zalo/zsplit/ZSplit;->sIsList:Ljava/util/HashMap;
    :h
    invoke-virtual {v0, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Ljava/lang/Boolean;
    if-eqz v1, :calc
    invoke-virtual {v1}, Ljava/lang/Boolean;->booleanValue()Z
    move-result v1
    return v1
    :calc
    move-object v1, p0
    const/4 v3, 0x0
    :l
    if-eqz v1, :done
    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object v2
    const-string v3, "RecyclerView"
    invoke-virtual {v2, v3}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v3
    if-nez v3, :done
    const-string v3, "android.widget.AbsListView"
    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :done
    invoke-virtual {v1}, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;
    move-result-object v1
    goto :l
    :done
    invoke-static {v3}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;
    move-result-object v2
    invoke-virtual {v0, p0, v2}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    return v3
.end method

.method static padLists(Landroid/view/View;III)V
    .locals 6
    instance-of v0, p0, Landroid/view/ViewGroup;
    if-eqz v0, :out
    const/16 v0, 0xc
    if-gt p3, v0, :out
    invoke-virtual {p0}, Landroid/view/View;->getVisibility()I
    move-result v0
    const/16 v1, 0x8
    if-eq v0, v1, :out
    check-cast p0, Landroid/view/ViewGroup;
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v0
    invoke-static {v0}, Lcom/zing/zalo/zsplit/ZSplit;->isList(Ljava/lang/Class;)Z
    move-result v0
    if-eqz v0, :rec
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I
    move-result v0
    if-lt v0, p2, :rec
    invoke-virtual {p0}, Landroid/view/View;->getPaddingBottom()I
    move-result v0
    if-ge v0, p1, :cl
    invoke-virtual {p0}, Landroid/view/View;->getPaddingLeft()I
    move-result v0
    invoke-virtual {p0}, Landroid/view/View;->getPaddingTop()I
    move-result v1
    invoke-virtual {p0}, Landroid/view/View;->getPaddingRight()I
    move-result v2
    invoke-virtual {p0, v0, v1, v2, p1}, Landroid/view/View;->setPadding(IIII)V
    :cl
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getClipToPadding()Z
    move-result v0
    if-eqz v0, :out
    const/4 v0, 0x0
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->setClipToPadding(Z)V
    goto :out
    :rec
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v0
    const/4 v1, 0x0
    add-int/lit8 v3, p3, 0x1
    :l
    if-ge v1, v0, :out
    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v2
    invoke-static {v2, p1, p2, v3}, Lcom/zing/zalo/zsplit/ZSplit;->padLists(Landroid/view/View;III)V
    add-int/lit8 v1, v1, 0x1
    goto :l
    :out
    return-void
.end method

.method static noRipple(Landroid/view/View;)V
    .locals 4
    invoke-virtual {p0}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;
    move-result-object v0
    instance-of v0, v0, Landroid/graphics/drawable/RippleDrawable;
    if-eqz v0, :f
    const/4 v0, 0x0
    invoke-virtual {p0, v0}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    :f
    invoke-virtual {p0}, Landroid/view/View;->getForeground()Landroid/graphics/drawable/Drawable;
    move-result-object v0
    instance-of v0, v0, Landroid/graphics/drawable/RippleDrawable;
    if-eqz v0, :g
    const/4 v0, 0x0
    invoke-virtual {p0, v0}, Landroid/view/View;->setForeground(Landroid/graphics/drawable/Drawable;)V
    :g
    instance-of v0, p0, Landroid/view/ViewGroup;
    if-eqz v0, :out
    check-cast p0, Landroid/view/ViewGroup;
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v1
    const/4 v2, 0x0
    :l
    if-ge v2, v1, :out
    invoke-virtual {p0, v2}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v3
    invoke-static {v3}, Lcom/zing/zalo/zsplit/ZSplit;->noRipple(Landroid/view/View;)V
    add-int/lit8 v2, v2, 0x1
    goto :l
    :out
    return-void
.end method
