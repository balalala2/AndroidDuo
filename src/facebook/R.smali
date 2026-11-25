.class final Lcom/zsplit/fb/FSplit$R;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final a:Ljava/lang/ref/WeakReference;

.method constructor <init>(Ljava/lang/ref/WeakReference;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/zsplit/fb/FSplit$R;->a:Ljava/lang/ref/WeakReference;
    return-void
.end method

.method public run()V
    .locals 2
    :try_start
    iget-object v0, p0, Lcom/zsplit/fb/FSplit$R;->a:Ljava/lang/ref/WeakReference;
    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/app/Activity;
    if-eqz v0, :e
    invoke-virtual {v0}, Landroid/app/Activity;->isFinishing()Z
    move-result v1
    if-nez v1, :e
    invoke-virtual {v0}, Landroid/app/Activity;->recreate()V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :e
    :e
    return-void
.end method
