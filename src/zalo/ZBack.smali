.class public final Lcom/zing/zalo/zsplit/ZBack;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 1
    :try_start
    invoke-virtual {p1}, Landroid/view/View;->isShown()Z
    move-result v0
    if-eqz v0, :e
    const/16 v0, 0x8
    invoke-virtual {p1, v0}, Landroid/view/View;->setVisibility(I)V
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v0
    invoke-static {v0}, Lcom/zing/zalo/zsplit/ZFix;->activityOf(Landroid/content/Context;)Landroid/app/Activity;
    move-result-object v0
    if-eqz v0, :e
    invoke-virtual {v0}, Landroid/app/Activity;->onBackPressed()V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :e
    :e
    return-void
.end method
