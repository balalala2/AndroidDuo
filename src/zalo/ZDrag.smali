.class public final Lcom/zing/zalo/zsplit/ZDrag;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnTouchListener;

.field public g:Lcom/zing/zalo/zsplit/ZGlass;
.field public downX:F
.field public dragging:Z

.method public constructor <init>(Lcom/zing/zalo/zsplit/ZGlass;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/zing/zalo/zsplit/ZDrag;->g:Lcom/zing/zalo/zsplit/ZGlass;
    return-void
.end method

.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 9
    :try_start
    iget-object v0, p0, Lcom/zing/zalo/zsplit/ZDrag;->g:Lcom/zing/zalo/zsplit/ZGlass;
    iget-object v1, v0, Lcom/zing/zalo/zsplit/ZGlass;->host:Landroid/view/View;
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getActionMasked()I
    move-result v2
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F
    move-result v3
    const/4 v4, 0x2
    new-array v4, v4, [I
    invoke-virtual {v1, v4}, Landroid/view/View;->getLocationOnScreen([I)V
    const/4 v5, 0x0
    aget v4, v4, v5
    int-to-float v4, v4
    sub-float v4, v3, v4
    # v4 = host-local x
    if-nez v2, :notdown
    iput v3, p0, Lcom/zing/zalo/zsplit/ZDrag;->downX:F
    iput-boolean v5, p0, Lcom/zing/zalo/zsplit/ZDrag;->dragging:Z
    return v5
    :notdown
    iget-boolean v6, p0, Lcom/zing/zalo/zsplit/ZDrag;->dragging:Z
    const/4 v7, 0x2
    if-ne v2, v7, :notmove
    if-nez v6, :mv
    iget v7, p0, Lcom/zing/zalo/zsplit/ZDrag;->downX:F
    sub-float v7, v3, v7
    invoke-static {v7}, Ljava/lang/Math;->abs(F)F
    move-result v7
    invoke-virtual {v1}, Landroid/view/View;->getResources()Landroid/content/res/Resources;
    move-result-object v8
    invoke-virtual {v8}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v8
    iget v8, v8, Landroid/util/DisplayMetrics;->density:F
    const/high16 v6, 0x41200000
    mul-float/2addr v8, v6
    cmpl-float v7, v7, v8
    if-gtz v7, :start
    return v5
    :start
    const/4 v6, 0x1
    iput-boolean v6, p0, Lcom/zing/zalo/zsplit/ZDrag;->dragging:Z
    invoke-virtual {v1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;
    move-result-object v7
    if-eqz v7, :np
    invoke-interface {v7, v6}, Landroid/view/ViewParent;->requestDisallowInterceptTouchEvent(Z)V
    :np
    invoke-static {p2}, Landroid/view/MotionEvent;->obtain(Landroid/view/MotionEvent;)Landroid/view/MotionEvent;
    move-result-object v7
    const/4 v8, 0x3
    invoke-virtual {v7, v8}, Landroid/view/MotionEvent;->setAction(I)V
    invoke-virtual {p1, v7}, Landroid/view/View;->onTouchEvent(Landroid/view/MotionEvent;)Z
    invoke-virtual {v7}, Landroid/view/MotionEvent;->recycle()V
    invoke-virtual {p1, v5}, Landroid/view/View;->setPressed(Z)V
    :mv
    invoke-virtual {v0, v4}, Lcom/zing/zalo/zsplit/ZGlass;->posFromX(F)F
    move-result v7
    iput v7, v0, Lcom/zing/zalo/zsplit/ZGlass;->drag:F
    invoke-virtual {v1}, Landroid/view/View;->invalidate()V
    const/4 v7, 0x1
    return v7
    :notmove
    if-eqz v6, :ret
    iput-boolean v5, p0, Lcom/zing/zalo/zsplit/ZDrag;->dragging:Z
    iget v6, v0, Lcom/zing/zalo/zsplit/ZGlass;->drag:F
    const/high16 v7, 0x7fc00000
    iput v7, v0, Lcom/zing/zalo/zsplit/ZGlass;->drag:F
    const/4 v7, 0x1
    if-ne v2, v7, :inv
    invoke-static {v6}, Ljava/lang/Math;->round(F)I
    move-result v6
    int-to-float v7, v6
    iput v7, v0, Lcom/zing/zalo/zsplit/ZGlass;->hold:F
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J
    move-result-wide v7
    const-wide/16 v2, 0x2bc
    add-long/2addr v7, v2
    iput-wide v7, v0, Lcom/zing/zalo/zsplit/ZGlass;->holdT:J
    invoke-virtual {v0}, Lcom/zing/zalo/zsplit/ZGlass;->pagerPos()F
    move-result v2
    invoke-static {v2}, Ljava/lang/Math;->round(F)I
    move-result v2
    if-eq v2, v6, :inv
    invoke-virtual {v0}, Lcom/zing/zalo/zsplit/ZGlass;->tabs()Landroid/view/ViewGroup;
    move-result-object v2
    if-eqz v2, :inv
    invoke-static {v2, v6}, Lcom/zing/zalo/zsplit/ZGlass;->kid(Landroid/view/ViewGroup;I)Landroid/view/View;
    move-result-object v2
    if-eqz v2, :inv
    invoke-virtual {v2}, Landroid/view/View;->performClick()Z
    :inv
    invoke-virtual {v1}, Landroid/view/View;->invalidate()V
    const/4 v7, 0x1
    return v7
    :ret
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :e
    :e
    const/4 v0, 0x0
    return v0
.end method
