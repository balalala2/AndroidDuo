.class final Lcom/zsplit/fb/FSplit$N;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final r:Landroid/view/View;

.method constructor <init>(Landroid/view/View;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/zsplit/fb/FSplit$N;->r:Landroid/view/View;
    return-void
.end method

.method public run()V
    .locals 2
    :try_start
    iget-object v0, p0, Lcom/zsplit/fb/FSplit$N;->r:Landroid/view/View;
    invoke-static {v0}, Lcom/zsplit/fb/FSplit;->findPager(Landroid/view/View;)Landroid/view/View;
    move-result-object v0
    if-eqz v0, :e
    const/4 v1, 0x0
    invoke-static {v0, v1}, Lcom/zsplit/fb/FSplit;->rebind(Landroid/view/View;I)V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :e
    :e
    return-void
.end method
