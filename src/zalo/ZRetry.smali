.class public final Lcom/zing/zalo/zsplit/ZRetry;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final mgr:Lcom/zing/zalo/zview/b;

.field n:I


# direct methods
.method constructor <init>(Lcom/zing/zalo/zview/b;)V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/zing/zalo/zsplit/ZRetry;->mgr:Lcom/zing/zalo/zview/b;

    const/16 v0, 0x14

    iput v0, p0, Lcom/zing/zalo/zsplit/ZRetry;->n:I

    return-void
.end method

.method public static schedule(Lcom/zing/zalo/zview/b;)V
    .locals 4

    :try_start_0
    new-instance v0, Lcom/zing/zalo/zsplit/ZRetry;

    invoke-direct {v0, p0}, Lcom/zing/zalo/zsplit/ZRetry;-><init>(Lcom/zing/zalo/zview/b;)V

    new-instance v1, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    const-wide/16 v2, 0xc8

    invoke-virtual {v1, v0, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_13

    :catch_13
    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    :try_start_0
    iget-object v0, p0, Lcom/zing/zalo/zsplit/ZRetry;->mgr:Lcom/zing/zalo/zview/b;

    invoke-static {v0}, Lcom/zing/zalo/zsplit/ZSplit;->tryInstall(Lcom/zing/zalo/zview/b;)Z

    move-result v0

    if-nez v0, :cond_1e

    iget v0, p0, Lcom/zing/zalo/zsplit/ZRetry;->n:I

    add-int/lit8 v0, v0, -0x1

    iput v0, p0, Lcom/zing/zalo/zsplit/ZRetry;->n:I

    if-lez v0, :cond_1e

    new-instance v1, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    const-wide/16 v2, 0x12c

    invoke-virtual {v1, p0, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_1e

    :catch_1e
    :cond_1e
    return-void
.end method


