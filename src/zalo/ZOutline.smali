.class public final Lcom/zing/zalo/zsplit/ZOutline;
.super Landroid/view/ViewOutlineProvider;

.field final r:F

.method public constructor <init>(F)V
    .locals 0
    invoke-direct {p0}, Landroid/view/ViewOutlineProvider;-><init>()V
    iput p1, p0, Lcom/zing/zalo/zsplit/ZOutline;->r:F
    return-void
.end method

.method public getOutline(Landroid/view/View;Landroid/graphics/Outline;)V
    .locals 6
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I
    move-result v3
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I
    move-result v4
    const/4 v1, 0x0
    const/4 v2, 0x0
    iget v5, p0, Lcom/zing/zalo/zsplit/ZOutline;->r:F
    const/4 v0, 0x0
    cmpg-float v0, v5, v0
    if-gez v0, :ok
    int-to-float v5, v4
    const/high16 v0, 0x40000000
    div-float/2addr v5, v0
    :ok
    move-object v0, p2
    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Outline;->setRoundRect(IIIIF)V
    return-void
.end method
