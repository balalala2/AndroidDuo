.class final Lcom/zsplit/fb/FSplit$L;
.super Ljava/lang/Object;
# interfaces
.implements Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;
# instance fields
.field final a:Ljava/lang/ref/WeakReference;
.field last:I
.field final r:Landroid/view/View;
# direct methods
.method constructor <init>(Landroid/view/View;Landroid/app/Activity;)V
    .locals 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/zsplit/fb/FSplit$L;->r:Landroid/view/View;
    new-instance v0, Ljava/lang/ref/WeakReference;
    invoke-direct {v0, p2}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V
    iput-object v0, p0, Lcom/zsplit/fb/FSplit$L;->a:Ljava/lang/ref/WeakReference;
    const/4 v0, -0x1
    iput v0, p0, Lcom/zsplit/fb/FSplit$L;->last:I
    return-void
.end method
# virtual methods
.method public onGlobalLayout()V
    .locals 8
    :try_start_0
    iget-object v0, p0, Lcom/zsplit/fb/FSplit$L;->r:Landroid/view/View;
    iget-object v1, p0, Lcom/zsplit/fb/FSplit$L;->a:Ljava/lang/ref/WeakReference;
    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Landroid/content/Context;
    if-nez v1, :cond_10
    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v1
    :cond_10
    invoke-static {v1}, Lcom/zsplit/fb/FSplit;->isWide(Landroid/content/Context;)Z
    move-result v1
    iget v2, p0, Lcom/zsplit/fb/FSplit$L;->last:I
    iput v1, p0, Lcom/zsplit/fb/FSplit$L;->last:I
    if-ltz v2, :cond_45
    if-eq v2, v1, :cond_45
    new-instance v3, Lcom/zsplit/fb/FSplit$N;
    invoke-direct {v3, v0}, Lcom/zsplit/fb/FSplit$N;-><init>(Landroid/view/View;)V
    const-wide/16 v4, 0x190
    invoke-virtual {v0, v3, v4, v5}, Landroid/view/View;->postDelayed(Ljava/lang/Runnable;J)Z
    goto :cond_45
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J
    move-result-wide v4
    sget-wide v6, Lcom/zsplit/fb/FSplit;->sRc:J
    sub-long v6, v4, v6
    const-wide/16 v2, 0xbb8
    cmp-long v6, v6, v2
    if-ltz v6, :cond_45
    sput-wide v4, Lcom/zsplit/fb/FSplit;->sRc:J
    iget-object v3, p0, Lcom/zsplit/fb/FSplit$L;->a:Ljava/lang/ref/WeakReference;
    invoke-virtual {v3}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;
    move-result-object v3
    check-cast v3, Landroid/app/Activity;
    if-eqz v3, :cond_45
    invoke-virtual {v3}, Landroid/app/Activity;->isFinishing()Z
    move-result v2
    if-nez v2, :cond_45
    const/4 v2, 0x2
    iput v2, p0, Lcom/zsplit/fb/FSplit$L;->last:I
    invoke-virtual {v3}, Landroid/app/Activity;->recreate()V
    return-void
    :cond_45
    invoke-static {v0}, Lcom/zsplit/fb/FSplit;->fix2(Landroid/view/View;)V
    sget-boolean v2, Lcom/zsplit/fb/FSplit;->sReq:Z
    if-eqz v2, :zs_nr
    const/4 v2, 0x0
    sput-boolean v2, Lcom/zsplit/fb/FSplit;->sReq:Z
    new-instance v3, Lcom/zsplit/fb/FSplit$R;
    iget-object v2, p0, Lcom/zsplit/fb/FSplit$L;->a:Ljava/lang/ref/WeakReference;
    invoke-direct {v3, v2}, Lcom/zsplit/fb/FSplit$R;-><init>(Ljava/lang/ref/WeakReference;)V
    const-wide/16 v4, 0x258
    invoke-virtual {v0, v3, v4, v5}, Landroid/view/View;->postDelayed(Ljava/lang/Runnable;J)Z
    :zs_nr
    if-eqz v1, :zs_end
    const/4 v2, 0x0
    invoke-static {v0, v2}, Lcom/zsplit/fb/FSplit;->phone(Landroid/view/View;I)Z
    move-result v2
    if-eqz v2, :zs_end
    sget v2, Lcom/zsplit/fb/FSplit;->sN:I
    const/4 v3, 0x2
    if-ge v2, v3, :zs_end
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J
    move-result-wide v4
    sget-wide v6, Lcom/zsplit/fb/FSplit;->sRc:J
    sub-long v6, v4, v6
    const-wide/16 v2, 0xbb8
    cmp-long v6, v6, v2
    if-ltz v6, :zs_end
    sput-wide v4, Lcom/zsplit/fb/FSplit;->sRc:J
    iget-object v3, p0, Lcom/zsplit/fb/FSplit$L;->a:Ljava/lang/ref/WeakReference;
    invoke-virtual {v3}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;
    move-result-object v3
    check-cast v3, Landroid/app/Activity;
    if-eqz v3, :zs_end
    invoke-virtual {v3}, Landroid/app/Activity;->isFinishing()Z
    move-result v2
    if-nez v2, :zs_end
    sget v2, Lcom/zsplit/fb/FSplit;->sN:I
    add-int/lit8 v2, v2, 0x1
    sput v2, Lcom/zsplit/fb/FSplit;->sN:I
    invoke-virtual {v3}, Landroid/app/Activity;->recreate()V
    :zs_end
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_48
    :catch_48
    return-void
.end method
