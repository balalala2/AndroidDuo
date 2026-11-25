.class public final Lcom/zing/zalo/zsplit/ZFix;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final mgr:Lcom/zing/zalo/zview/b;
.field stage:I
.field args:Landroid/os/Bundle;

.method constructor <init>(Lcom/zing/zalo/zview/b;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/zing/zalo/zsplit/ZFix;->mgr:Lcom/zing/zalo/zview/b;
    return-void
.end method

.method public static schedule(Lcom/zing/zalo/zview/b;)V
    .locals 4
    :try_start
    invoke-static {p0}, Lcom/zing/zalo/zsplit/ZRetry;->schedule(Lcom/zing/zalo/zview/b;)V
    new-instance v0, Lcom/zing/zalo/zsplit/ZFix;
    invoke-direct {v0, p0}, Lcom/zing/zalo/zsplit/ZFix;-><init>(Lcom/zing/zalo/zview/b;)V
    new-instance v1, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v2
    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V
    const-wide/16 v2, 0x2bc
    invoke-virtual {v1, v0, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :e
    :e
    return-void
.end method

.method static activityOf(Landroid/content/Context;)Landroid/app/Activity;
    .locals 1
    :loop
    if-eqz p0, :nul
    instance-of v0, p0, Landroid/app/Activity;
    if-eqz v0, :wrap
    check-cast p0, Landroid/app/Activity;
    return-object p0
    :wrap
    instance-of v0, p0, Landroid/content/ContextWrapper;
    if-eqz v0, :nul
    check-cast p0, Landroid/content/ContextWrapper;
    invoke-virtual {p0}, Landroid/content/ContextWrapper;->getBaseContext()Landroid/content/Context;
    move-result-object p0
    goto :loop
    :nul
    const/4 p0, 0x0
    return-object p0
.end method

.method public run()V
    .locals 10
    :try_start
    iget-object v0, p0, Lcom/zing/zalo/zsplit/ZFix;->mgr:Lcom/zing/zalo/zview/b;
    iget v1, p0, Lcom/zing/zalo/zsplit/ZFix;->stage:I
    if-nez v1, :push
    iget-object v1, v0, Lcom/zing/zalo/zview/b;->d:Ljava/util/ArrayList;
    if-eqz v1, :out
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I
    move-result v2
    const/4 v3, 0x2
    if-lt v2, v3, :out
    invoke-static {v1}, Lcom/zing/zalo/zsplit/ZSplit;->findMain(Ljava/util/ArrayList;)I
    move-result v3
    if-ltz v3, :out
    add-int/lit8 v4, v2, -0x2
    if-ne v3, v4, :out
    add-int/lit8 v4, v2, -0x1
    invoke-virtual {v1, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v4
    check-cast v4, Lcbo;
    iget-object v5, v4, Lcbo;->a:Ljava/lang/Class;
    const-class v6, Lcom/zing/zalo/ui/chat/ChatView;
    if-ne v5, v6, :out
    iget-object v5, v4, Lcbo;->b:Lvrv;
    if-eqz v5, :out
    iget-object v6, v5, Lvrv;->e:Landroid/os/Bundle;
    if-eqz v6, :out
    invoke-virtual {v1, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v7
    check-cast v7, Lcbo;
    iget-object v7, v7, Lcbo;->b:Lvrv;
    if-eqz v7, :out
    iget-object v7, v7, Lvrv;->x:Landroid/view/View;
    if-eqz v7, :out
    invoke-virtual {v7}, Landroid/view/View;->getParent()Landroid/view/ViewParent;
    move-result-object v8
    instance-of v9, v8, Landroid/view/View;
    if-eqz v9, :out
    check-cast v8, Landroid/view/View;
    invoke-static {v8}, Lcom/zing/zalo/zsplit/ZSplit;->isWide(Landroid/view/View;)Z
    move-result v9
    if-eqz v9, :out
    invoke-virtual {v7}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v8
    invoke-static {v8}, Lcom/zing/zalo/zsplit/ZFix;->activityOf(Landroid/content/Context;)Landroid/app/Activity;
    move-result-object v8
    if-eqz v8, :out
    new-instance v9, Landroid/os/Bundle;
    invoke-direct {v9, v6}, Landroid/os/Bundle;-><init>(Landroid/os/Bundle;)V
    iput-object v9, p0, Lcom/zing/zalo/zsplit/ZFix;->args:Landroid/os/Bundle;
    const/4 v9, 0x1
    iput v9, p0, Lcom/zing/zalo/zsplit/ZFix;->stage:I
    invoke-virtual {v8}, Landroid/app/Activity;->onBackPressed()V
    new-instance v1, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v2
    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V
    const-wide/16 v2, 0x15e
    invoke-virtual {v1, p0, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    goto :out
    :push
    const/4 v1, 0x2
    iput v1, p0, Lcom/zing/zalo/zsplit/ZFix;->stage:I
    const-class v1, Lcom/zing/zalo/ui/chat/ChatView;
    iget-object v2, p0, Lcom/zing/zalo/zsplit/ZFix;->args:Landroid/os/Bundle;
    const/4 v3, 0x0
    const/4 v4, 0x0
    const/4 v5, 0x0
    const/4 v6, 0x1
    invoke-static {v0, v1, v2}, Lcom/zing/zalo/zsplit/ZFix;->push(Lcom/zing/zalo/zview/b;Ljava/lang/Class;Landroid/os/Bundle;)V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :out
    :out
    return-void
.end method

.method static push(Lcom/zing/zalo/zview/b;Ljava/lang/Class;Landroid/os/Bundle;)V
    .locals 7
    move-object v0, p0
    move-object v1, p1
    move-object v2, p2
    const/4 v3, 0x0
    const/4 v4, 0x0
    const/4 v5, 0x0
    const/4 v6, 0x1
    invoke-virtual/range {v0 .. v6}, Lcom/zing/zalo/zview/b;->R0(Ljava/lang/Class;Landroid/os/Bundle;ILjava/lang/String;IZ)V
    return-void
.end method
