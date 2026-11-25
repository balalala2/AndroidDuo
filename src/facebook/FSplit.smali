.class public final Lcom/zsplit/fb/FSplit;
.super Ljava/lang/Object;
# static fields
.field static sHdr:Ljava/lang/ref/WeakReference;
.field static sN:I
.field static sRc:J
.field static sReq:Z
# direct methods

.method static bg(Landroid/view/View;Landroid/view/View;)V
    .locals 4
    const v0, 0x7a5f0003
    invoke-virtual {p1, v0}, Landroid/view/View;->getTag(I)Ljava/lang/Object;
    move-result-object v1
    if-nez v1, :cond_2e
    move-object v1, p0
    :goto_a
    invoke-virtual {v1}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;
    move-result-object v2
    if-nez v2, :cond_1c
    invoke-virtual {v1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;
    move-result-object v3
    instance-of v2, v3, Landroid/view/View;
    if-eqz v2, :cond_2e
    move-object v1, v3
    check-cast v1, Landroid/view/View;
    goto :goto_a
    :cond_1c
    invoke-virtual {v2}, Landroid/graphics/drawable/Drawable;->getConstantState()Landroid/graphics/drawable/Drawable$ConstantState;
    move-result-object v3
    if-eqz v3, :cond_2e
    invoke-virtual {v3}, Landroid/graphics/drawable/Drawable$ConstantState;->newDrawable()Landroid/graphics/drawable/Drawable;
    move-result-object v3
    invoke-virtual {p1, v3}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    sget-object v3, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;
    invoke-virtual {p1, v0, v3}, Landroid/view/View;->setTag(ILjava/lang/Object;)V
    :cond_2e
    return-void
.end method

.method static compact(Landroid/view/View;I)V
    .locals 8
    move-object v0, p0
    check-cast v0, Landroid/widget/LinearLayout;
    invoke-virtual {v0}, Landroid/widget/LinearLayout;->getOrientation()I
    move-result v1
    const/4 v2, 0x1
    if-eq v1, v2, :zs_or
    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V
    :zs_or
    invoke-virtual {p0}, Landroid/view/View;->getMinimumHeight()I
    move-result v0
    if-eq v0, p1, :cond_9
    invoke-virtual {p0, p1}, Landroid/view/View;->setMinimumHeight(I)V
    :cond_9
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;
    move-result-object v0
    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v0
    iget v0, v0, Landroid/util/DisplayMetrics;->density:F
    const/high16 v1, 0x42a00000    # 80.0f
    mul-float/2addr v0, v1
    float-to-int v0, v0
    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    move-result-object v1
    if-eqz v1, :cond_26
    iget v2, v1, Landroid/view/ViewGroup$LayoutParams;->height:I
    if-lez v2, :zs_hok
    const/4 v2, -0x1
    iput v2, v1, Landroid/view/ViewGroup$LayoutParams;->height:I
    iput v0, v1, Landroid/view/ViewGroup$LayoutParams;->width:I
    invoke-virtual {p0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    goto :cond_26
    :zs_hok
    iget v2, v1, Landroid/view/ViewGroup$LayoutParams;->width:I
    if-eq v2, v0, :cond_26
    iput v0, v1, Landroid/view/ViewGroup$LayoutParams;->width:I
    invoke-virtual {p0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    :cond_26
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;
    move-result-object v0
    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v0
    iget v0, v0, Landroid/util/DisplayMetrics;->density:F
    const/high16 v1, 0x42680000    # 58.0f
    mul-float/2addr v0, v1
    float-to-int v0, v0
    check-cast p0, Landroid/view/ViewGroup;
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v1
    const/4 v2, 0x0
    :goto_3b
    if-ge v2, v1, :cond_7f
    invoke-virtual {p0, v2}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v3
    invoke-virtual {v3}, Landroid/view/View;->getContentDescription()Ljava/lang/CharSequence;
    move-result-object v4
    if-eqz v4, :cond_5f
    invoke-interface {v4}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;
    move-result-object v4
    const-string v5, "Reels"
    invoke-virtual {v4, v5}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v4
    if-eqz v4, :cond_5f
    invoke-virtual {v3}, Landroid/view/View;->getVisibility()I
    move-result v4
    const/16 v5, 0x8
    if-eq v4, v5, :cond_7c
    invoke-virtual {v3, v5}, Landroid/view/View;->setVisibility(I)V
    goto :goto_7c
    :cond_5f
    invoke-virtual {v3}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    move-result-object v4
    instance-of v5, v4, Landroid/widget/LinearLayout$LayoutParams;
    if-eqz v5, :cond_7c
    check-cast v4, Landroid/widget/LinearLayout$LayoutParams;
    iget v5, v4, Landroid/widget/LinearLayout$LayoutParams;->width:I
    const/4 v6, -0x1
    if-ne v5, v6, :cond_74
    iget v5, v4, Landroid/widget/LinearLayout$LayoutParams;->height:I
    if-ne v5, v0, :cond_74
    iget v5, v4, Landroid/widget/LinearLayout$LayoutParams;->weight:F
    const/4 v6, 0x0
    cmpl-float v5, v5, v6
    if-eqz v5, :cond_7c
    :cond_74
    iput v0, v4, Landroid/widget/LinearLayout$LayoutParams;->height:I
    const/4 v6, -0x1
    iput v6, v4, Landroid/widget/LinearLayout$LayoutParams;->width:I
    const/4 v6, 0x0
    iput v6, v4, Landroid/widget/LinearLayout$LayoutParams;->weight:F
    invoke-virtual {v3, v4}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    :cond_7c
    :goto_7c
    add-int/lit8 v2, v2, 0x1
    goto :goto_3b
    :cond_7f
    return-void
.end method

.method static findPager(Landroid/view/View;)Landroid/view/View;
    .locals 5
    instance-of v0, p0, Landroidx/viewpager/widget/ViewPager;
    if-eqz v0, :cond_5
    return-object p0
    :cond_5
    instance-of v0, p0, Landroid/view/ViewGroup;
    if-eqz v0, :cond_25
    instance-of v0, p0, Landroidx/recyclerview/widget/RecyclerView;
    if-nez v0, :cond_25
    move-object v0, p0
    check-cast v0, Landroid/view/ViewGroup;
    invoke-virtual {v0}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v1
    const/4 v2, 0x0
    :goto_15
    if-ge v2, v1, :cond_25
    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v3
    invoke-static {v3}, Lcom/zsplit/fb/FSplit;->findPager(Landroid/view/View;)Landroid/view/View;
    move-result-object v4
    if-eqz v4, :cond_22
    return-object v4
    :cond_22
    add-int/lit8 v2, v2, 0x1
    goto :goto_15
    :cond_25
    const/4 v0, 0x0
    return-object v0
.end method

.method static findRail(Landroid/view/View;I)Landroid/view/View;
    .locals 6
    instance-of v0, p0, Landroid/view/ViewGroup;
    if-eqz v0, :cond_55
    instance-of v0, p0, Landroidx/recyclerview/widget/RecyclerView;
    if-nez v0, :cond_55
    instance-of v0, p0, Landroidx/viewpager/widget/ViewPager;
    if-nez v0, :cond_55
    invoke-virtual {p0}, Landroid/view/View;->getVisibility()I
    move-result v0
    if-nez v0, :cond_55
    instance-of v0, p0, Landroid/widget/LinearLayout;
    if-eqz v0, :cond_3d
    move-object v0, p0
    check-cast v0, Landroid/widget/LinearLayout;
    invoke-virtual {v0}, Landroid/widget/LinearLayout;->getOrientation()I
    move-result v1
    const/4 v2, 0x1
    if-ne v1, v2, :cond_3d
    invoke-virtual {v0}, Landroid/widget/LinearLayout;->getChildCount()I
    move-result v1
    const/4 v2, 0x4
    if-lt v1, v2, :cond_3d
    const/4 v2, 0x7
    if-gt v1, v2, :cond_3d
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I
    move-result v1
    if-lez v1, :cond_3d
    mul-int/lit8 v2, v1, 0x4
    if-gt v2, p1, :cond_3d
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I
    move-result v2
    mul-int/lit8 v3, v1, 0x3
    if-lt v2, v3, :cond_3d
    return-object p0
    :cond_3d
    move-object v0, p0
    check-cast v0, Landroid/view/ViewGroup;
    invoke-virtual {v0}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v1
    const/4 v2, 0x0
    :goto_45
    if-ge v2, v1, :cond_55
    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v3
    invoke-static {v3, p1}, Lcom/zsplit/fb/FSplit;->findRail(Landroid/view/View;I)Landroid/view/View;
    move-result-object v4
    if-eqz v4, :cond_52
    return-object v4
    :cond_52
    add-int/lit8 v2, v2, 0x1
    goto :goto_45
    :cond_55
    const/4 v0, 0x0
    return-object v0
.end method

.method static fix(Landroid/view/View;)V
    .locals 12
    invoke-static {p0}, Lcom/zsplit/fb/FSplit;->findPager(Landroid/view/View;)Landroid/view/View;
    move-result-object v1
    if-eqz v1, :cond_9c
    const/4 v2, 0x0
    const/4 v6, 0x0
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v0
    invoke-static {v0}, Lcom/zsplit/fb/FSplit;->isWide(Landroid/content/Context;)Z
    move-result v0
    if-eqz v0, :cond_69
    invoke-virtual {v1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;
    move-result-object v7
    instance-of v0, v7, Landroid/widget/FrameLayout;
    if-eqz v0, :cond_69
    check-cast v7, Landroid/view/View;
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I
    move-result v3
    invoke-static {p0, v3}, Lcom/zsplit/fb/FSplit;->findRail(Landroid/view/View;I)Landroid/view/View;
    move-result-object v4
    if-eqz v4, :cond_69
    invoke-virtual {v4}, Landroid/view/View;->isShown()Z
    move-result v5
    if-eqz v5, :cond_69
    const/4 v10, 0x2
    new-array v3, v10, [I
    new-array v8, v10, [I
    invoke-virtual {v4, v3}, Landroid/view/View;->getLocationInWindow([I)V
    invoke-virtual {v7, v8}, Landroid/view/View;->getLocationInWindow([I)V
    const/4 v0, 0x0
    aget v2, v3, v0
    aget v5, v8, v0
    sub-int/2addr v2, v5
    invoke-virtual {v4}, Landroid/view/View;->getWidth()I
    move-result v5
    add-int/2addr v2, v5
    if-gez v2, :cond_45
    const/4 v2, 0x0
    :cond_45
    const/4 v0, 0x1
    aget v6, v3, v0
    aget v5, v8, v0
    sub-int/2addr v6, v5
    if-gez v6, :cond_4e
    const/4 v6, 0x0
    :cond_4e
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I
    move-result v11
    invoke-static {v4, v11}, Lcom/zsplit/fb/FSplit;->compact(Landroid/view/View;I)V
    invoke-virtual {v4}, Landroid/view/View;->getWidth()I
    move-result v11
    invoke-static {v4, v11}, Lcom/zsplit/fb/FSplit;->header(Landroid/view/View;I)V
    invoke-static {v4, v1}, Lcom/zsplit/fb/FSplit;->bg(Landroid/view/View;Landroid/view/View;)V
    const/4 v11, 0x0
    invoke-static {v1, v11}, Lcom/zsplit/fb/FSplit;->unalpha(Landroid/view/View;I)V
    invoke-static {v4, v1}, Lcom/zsplit/fb/FSplit;->sync(Landroid/view/View;Landroid/view/View;)V
    invoke-static {v1}, Lcom/zsplit/fb/FSplit;->surfs(Landroid/view/View;)V
    :cond_69
    if-nez v2, :cond_70
    const/4 v11, 0x0
    const/4 v10, 0x0
    invoke-static {v10, v11}, Lcom/zsplit/fb/FSplit;->header(Landroid/view/View;I)V
    :cond_70
    invoke-virtual {v1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    move-result-object v3
    instance-of v4, v3, Landroid/view/ViewGroup$MarginLayoutParams;
    if-eqz v4, :cond_9c
    check-cast v3, Landroid/view/ViewGroup$MarginLayoutParams;
    iget v4, v3, Landroid/view/ViewGroup$MarginLayoutParams;->leftMargin:I
    iget v5, v3, Landroid/view/ViewGroup$MarginLayoutParams;->topMargin:I
    if-ne v4, v2, :cond_83
    if-ne v5, v6, :cond_83
    goto :goto_9c
    :cond_83
    const v9, 0x7a5f0002
    if-nez v2, :cond_90
    if-nez v6, :cond_90
    invoke-virtual {v1, v9}, Landroid/view/View;->getTag(I)Ljava/lang/Object;
    move-result-object v4
    if-eqz v4, :cond_9c
    :cond_90
    iput v2, v3, Landroid/view/ViewGroup$MarginLayoutParams;->leftMargin:I
    iput v6, v3, Landroid/view/ViewGroup$MarginLayoutParams;->topMargin:I
    sget-object v4, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;
    invoke-virtual {v1, v9, v4}, Landroid/view/View;->setTag(ILjava/lang/Object;)V
    invoke-virtual {v1, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    :cond_9c
    :goto_9c
    return-void
.end method

.method public static flog(Landroid/content/Context;Ljava/lang/String;)V
    .locals 4
    :try_start_0
    sget v0, Lcom/zsplit/fb/FSplit;->sN:I
    const/16 v1, 0x190
    if-ge v0, v1, :cond_3b
    add-int/lit8 v0, v0, 0x1
    sput v0, Lcom/zsplit/fb/FSplit;->sN:I
    if-eqz p0, :cond_3b
    const/4 v0, 0x0
    invoke-virtual {p0, v0}, Landroid/content/Context;->getExternalFilesDir(Ljava/lang/String;)Ljava/io/File;
    move-result-object v0
    if-eqz v0, :cond_3b
    new-instance v1, Ljava/io/File;
    const-string v2, "zsplit.log"
    invoke-direct {v1, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    new-instance v0, Ljava/io/FileWriter;
    const/4 v2, 0x1
    invoke-direct {v0, v1, v2}, Ljava/io/FileWriter;-><init>(Ljava/io/File;Z)V
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v2
    invoke-static {v2, v3}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v0, v2}, Ljava/io/Writer;->write(Ljava/lang/String;)V
    const-string v2, " "
    invoke-virtual {v0, v2}, Ljava/io/Writer;->write(Ljava/lang/String;)V
    invoke-virtual {v0, p1}, Ljava/io/Writer;->write(Ljava/lang/String;)V
    const-string v2, "\n"
    invoke-virtual {v0, v2}, Ljava/io/Writer;->write(Ljava/lang/String;)V
    invoke-virtual {v0}, Ljava/io/Writer;->close()V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_3b
    :catch_3b
    :cond_3b
    return-void
.end method

.method static header(Landroid/view/View;I)V
    .locals 6
    const/4 v0, 0x0
    if-eqz p0, :cond_31
    move-object v1, p0
    :goto_4
    invoke-virtual {v1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;
    move-result-object v2
    instance-of v3, v2, Landroid/widget/LinearLayout;
    if-eqz v3, :cond_29
    move-object v3, v2
    check-cast v3, Landroid/widget/LinearLayout;
    invoke-virtual {v3}, Landroid/widget/LinearLayout;->getOrientation()I
    move-result v4
    const/4 v5, 0x1
    if-ne v4, v5, :cond_29
    invoke-virtual {v3, v1}, Landroid/view/ViewGroup;->indexOfChild(Landroid/view/View;)I
    move-result v4
    if-lez v4, :cond_29
    const/4 v4, 0x0
    invoke-virtual {v3, v4}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v0
    new-instance v4, Ljava/lang/ref/WeakReference;
    invoke-direct {v4, v0}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V
    sput-object v4, Lcom/zsplit/fb/FSplit;->sHdr:Ljava/lang/ref/WeakReference;
    goto :goto_40
    :cond_29
    instance-of v3, v2, Landroid/view/View;
    if-eqz v3, :cond_31
    move-object v1, v2
    check-cast v1, Landroid/view/View;
    goto :goto_4
    :cond_31
    sget-object v4, Lcom/zsplit/fb/FSplit;->sHdr:Ljava/lang/ref/WeakReference;
    if-eqz v4, :cond_55
    invoke-virtual {v4}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/view/View;
    if-eqz v0, :cond_55
    if-eqz p0, :cond_40
    const/4 p1, 0x0
    :cond_40
    :goto_40
    invoke-virtual {v0}, Landroid/view/View;->getPaddingLeft()I
    move-result v5
    if-eq v5, p1, :cond_55
    invoke-virtual {v0}, Landroid/view/View;->getPaddingTop()I
    move-result v3
    invoke-virtual {v0}, Landroid/view/View;->getPaddingRight()I
    move-result v4
    invoke-virtual {v0}, Landroid/view/View;->getPaddingBottom()I
    move-result v5
    invoke-virtual {v0, p1, v3, v4, v5}, Landroid/view/View;->setPadding(IIII)V
    :cond_55
    return-void
.end method

.method public static install(Landroid/app/Activity;)V
    .locals 3
    :try_start_0
    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;
    move-result-object v0
    if-eqz v0, :cond_26
    invoke-virtual {v0}, Landroid/view/Window;->peekDecorView()Landroid/view/View;
    move-result-object v0
    if-eqz v0, :cond_26
    const v1, 0x7a5f0001
    invoke-virtual {v0, v1}, Landroid/view/View;->getTag(I)Ljava/lang/Object;
    move-result-object v2
    if-nez v2, :cond_26
    sget-object v2, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;
    invoke-virtual {v0, v1, v2}, Landroid/view/View;->setTag(ILjava/lang/Object;)V
    new-instance v1, Lcom/zsplit/fb/FSplit$L;
    invoke-direct {v1, v0, p0}, Lcom/zsplit/fb/FSplit$L;-><init>(Landroid/view/View;Landroid/app/Activity;)V
    invoke-virtual {v0}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;
    move-result-object v2
    invoke-virtual {v2, v1}, Landroid/view/ViewTreeObserver;->addOnGlobalLayoutListener(Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_26
    :catch_26
    :cond_26
    return-void
.end method

.method public static isWide(Landroid/content/Context;)Z
    .locals 3
    :try_start_0
    if-eqz p0, :cond_28
    instance-of v0, p0, Landroid/app/Activity;
    if-eqz v0, :cond_c
    move-object v0, p0
    check-cast v0, Landroid/app/Activity;
    invoke-static {v0}, Lcom/zsplit/fb/FSplit;->install(Landroid/app/Activity;)V
    :cond_c
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v0
    invoke-virtual {v0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;
    move-result-object v0
    iget v1, v0, Landroid/content/res/Configuration;->screenWidthDp:I
    iget v2, v0, Landroid/content/res/Configuration;->screenHeightDp:I
    const/16 v0, 0x258
    if-ge v1, v0, :cond_26
    const/16 v0, 0x17c
    if-lt v1, v0, :cond_28
    mul-int/lit8 v1, v1, 0xa
    mul-int/lit8 v2, v2, 0x8
    if-lt v1, v2, :cond_28
    :cond_26
    const/4 v0, 0x1
    return v0
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_28
    :catch_28
    :cond_28
    const/4 v0, 0x0
    return v0
.end method

.method public static pin(J)Z
    .locals 2
    const/16 v0, 0x20
    ushr-long v0, p0, v0
    long-to-int v0, v0
    const v1, 0x101082a
    if-ne v0, v1, :cond_c
    const/4 v0, 0x1
    return v0
    :cond_c
    const/4 v0, 0x0
    return v0
.end method

.method static surf(Landroid/view/View;III)V
    .locals 8
    instance-of v0, p0, Landroid/view/SurfaceView;
    if-eqz v0, :cond_3c
    const/4 v0, 0x2
    new-array v0, v0, [I
    invoke-virtual {p0, v0}, Landroid/view/View;->getLocationInWindow([I)V
    const/4 v1, 0x0
    aget v1, v0, v1
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I
    move-result v2
    add-int/2addr v2, v1
    const/4 v3, 0x0
    if-ge v1, p2, :cond_18
    if-le v2, p1, :cond_18
    const/4 v3, 0x1
    :cond_18
    const v4, 0x7a5f0004
    invoke-virtual {p0}, Landroid/view/View;->getVisibility()I
    move-result v5
    if-nez v3, :cond_2d
    if-nez v5, :cond_5a
    const/4 v6, 0x4
    invoke-virtual {p0, v6}, Landroid/view/View;->setVisibility(I)V
    sget-object v6, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;
    invoke-virtual {p0, v4, v6}, Landroid/view/View;->setTag(ILjava/lang/Object;)V
    goto :goto_5a
    :cond_2d
    invoke-virtual {p0, v4}, Landroid/view/View;->getTag(I)Ljava/lang/Object;
    move-result-object v6
    if-eqz v6, :cond_5a
    const/4 v6, 0x0
    invoke-virtual {p0, v4, v6}, Landroid/view/View;->setTag(ILjava/lang/Object;)V
    const/4 v7, 0x0
    invoke-virtual {p0, v7}, Landroid/view/View;->setVisibility(I)V
    goto :goto_5a
    :cond_3c
    instance-of v0, p0, Landroid/view/ViewGroup;
    if-eqz v0, :cond_5a
    const/16 v0, 0x28
    if-ge p3, v0, :cond_5a
    move-object v0, p0
    check-cast v0, Landroid/view/ViewGroup;
    invoke-virtual {v0}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v1
    add-int/lit8 v2, p3, 0x1
    const/4 v3, 0x0
    :goto_4e
    if-ge v3, v1, :cond_5a
    invoke-virtual {v0, v3}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v4
    invoke-static {v4, p1, p2, v2}, Lcom/zsplit/fb/FSplit;->surf(Landroid/view/View;III)V
    add-int/lit8 v3, v3, 0x1
    goto :goto_4e
    :cond_5a
    :goto_5a
    return-void
.end method

.method static surfs(Landroid/view/View;)V
    .locals 4
    :try_start_0
    const/4 v0, 0x2
    new-array v0, v0, [I
    invoke-virtual {p0, v0}, Landroid/view/View;->getLocationInWindow([I)V
    const/4 v1, 0x0
    aget v1, v0, v1
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I
    move-result v2
    add-int/2addr v2, v1
    const/4 v3, 0x0
    invoke-static {p0, v1, v2, v3}, Lcom/zsplit/fb/FSplit;->surf(Landroid/view/View;III)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_12
    :catch_12
    return-void
.end method

.method static sync(Landroid/view/View;Landroid/view/View;)V
    .locals 7
    :try_start_0
    check-cast p0, Landroid/view/ViewGroup;
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v0
    const/4 v1, 0x0
    const/4 v2, -0x1
    :goto_8
    if-ge v1, v0, :cond_19
    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v3
    invoke-virtual {v3}, Landroid/view/View;->isSelected()Z
    move-result v3
    if-eqz v3, :cond_16
    move v2, v1
    goto :goto_19
    :cond_16
    add-int/lit8 v1, v1, 0x1
    goto :goto_8
    :cond_19
    :goto_19
    if-ltz v2, :cond_52
    invoke-virtual {p0, v2}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v3
    invoke-virtual {v3}, Landroid/view/View;->getVisibility()I
    move-result v3
    const/16 v4, 0x8
    if-ne v3, v4, :zs_vis
    const/4 v3, 0x0
    invoke-virtual {p0, v3}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v3
    invoke-virtual {v3}, Landroid/view/View;->performClick()Z
    const/4 v3, 0x1
    sput-boolean v3, Lcom/zsplit/fb/FSplit;->sReq:Z
    goto :cond_52
    :zs_vis
    check-cast p1, Landroidx/viewpager/widget/ViewPager;
    invoke-virtual {p1}, Landroidx/viewpager/widget/ViewPager;->getAdapter()Landroidx/viewpager/widget/PagerAdapter;
    move-result-object v3
    if-eqz v3, :cond_52
    invoke-virtual {v3}, Landroidx/viewpager/widget/PagerAdapter;->getCount()I
    move-result v3
    if-ge v2, v3, :cond_52
    invoke-virtual {p1}, Landroidx/viewpager/widget/ViewPager;->getCurrentItem()I
    move-result v3
    if-eq v3, v2, :cond_34
    const/4 v4, 0x0
    invoke-virtual {p1, v2, v4}, Landroidx/viewpager/widget/ViewPager;->setCurrentItem(IZ)V
    goto :goto_52
    :cond_34
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I
    move-result v4
    invoke-virtual {p1}, Landroid/view/View;->getPaddingLeft()I
    move-result v5
    sub-int/2addr v4, v5
    invoke-virtual {p1}, Landroid/view/View;->getPaddingRight()I
    move-result v5
    sub-int/2addr v4, v5
    invoke-virtual {p1}, Landroidx/viewpager/widget/ViewPager;->getPageMargin()I
    move-result v5
    add-int/2addr v4, v5
    mul-int/2addr v4, v2
    invoke-virtual {p1}, Landroid/view/View;->getScrollX()I
    move-result v5
    if-eq v5, v4, :cond_52
    const/4 v6, 0x0
    invoke-virtual {p1, v4, v6}, Landroid/view/View;->scrollTo(II)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_52
    :catch_52
    :cond_52
    :goto_52
    return-void
.end method

.method static unalpha(Landroid/view/View;I)V
    .locals 5
    invoke-virtual {p0}, Landroid/view/View;->getAlpha()F
    move-result v0
    const v1, 0x3d4ccccd    # 0.05f
    cmpg-float v0, v0, v1
    if-gez v0, :cond_16
    invoke-virtual {p0}, Landroid/view/View;->getVisibility()I
    move-result v0
    if-nez v0, :cond_16
    const/high16 v0, 0x3f800000
    invoke-virtual {p0, v0}, Landroid/view/View;->setAlpha(F)V
    :cond_16
    instance-of v0, p0, Landroidx/recyclerview/widget/RecyclerView;
    if-nez v0, :cond_38
    instance-of v0, p0, Landroid/view/ViewGroup;
    if-eqz v0, :cond_38
    const/16 v0, 0xc
    if-ge p1, v0, :cond_38
    add-int/lit8 v4, p1, 0x1
    move-object v1, p0
    check-cast v1, Landroid/view/ViewGroup;
    invoke-virtual {v1}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v2
    const/4 v0, 0x0
    :goto_2c
    if-ge v0, v2, :cond_38
    invoke-virtual {v1, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v3
    invoke-static {v3, v4}, Lcom/zsplit/fb/FSplit;->unalpha(Landroid/view/View;I)V
    add-int/lit8 v0, v0, 0x1
    goto :goto_2c
    :cond_38
    return-void
.end method

.method static phone(Landroid/view/View;I)Z
    .locals 6
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object v0
    const-string v1, "TabBarContainerLayout"
    invoke-virtual {v0, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v0
    if-eqz v0, :grp
    const v0, 0x7a5f0005
    invoke-virtual {p0, v0}, Landroid/view/View;->getTag(I)Ljava/lang/Object;
    move-result-object v0
    if-nez v0, :no
    invoke-virtual {p0}, Landroid/view/View;->isShown()Z
    move-result v0
    if-eqz v0, :no
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I
    move-result v0
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I
    move-result v1
    if-le v0, v1, :no
    const/4 v0, 0x1
    return v0
    :grp
    instance-of v0, p0, Landroid/view/ViewGroup;
    if-eqz v0, :no
    instance-of v0, p0, Landroidx/recyclerview/widget/RecyclerView;
    if-nez v0, :no
    instance-of v0, p0, Landroidx/viewpager/widget/ViewPager;
    if-nez v0, :no
    const/16 v0, 0x14
    if-ge p1, v0, :no
    move-object v1, p0
    check-cast v1, Landroid/view/ViewGroup;
    invoke-virtual {v1}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v2
    add-int/lit8 v5, p1, 0x1
    const/4 v3, 0x0
    :loop
    if-ge v3, v2, :no
    invoke-virtual {v1, v3}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v4
    invoke-static {v4, v5}, Lcom/zsplit/fb/FSplit;->phone(Landroid/view/View;I)Z
    move-result v4
    if-eqz v4, :nx
    const/4 v0, 0x1
    return v0
    :nx
    add-int/lit8 v3, v3, 0x1
    goto :loop
    :no
    const/4 v0, 0x0
    return v0
.end method

.method static findName(Landroid/view/View;Ljava/lang/String;I)Landroid/view/View;
    .locals 6
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object v0
    invoke-virtual {v0, p1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v0
    if-eqz v0, :grp
    return-object p0
    :grp
    instance-of v0, p0, Landroid/view/ViewGroup;
    if-eqz v0, :no
    instance-of v0, p0, Landroidx/recyclerview/widget/RecyclerView;
    if-nez v0, :no
    instance-of v0, p0, Landroidx/viewpager/widget/ViewPager;
    if-nez v0, :no
    const/16 v0, 0x14
    if-ge p2, v0, :no
    move-object v1, p0
    check-cast v1, Landroid/view/ViewGroup;
    invoke-virtual {v1}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v2
    add-int/lit8 v5, p2, 0x1
    const/4 v3, 0x0
    :loop
    if-ge v3, v2, :no
    invoke-virtual {v1, v3}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v4
    invoke-static {v4, p1, v5}, Lcom/zsplit/fb/FSplit;->findName(Landroid/view/View;Ljava/lang/String;I)Landroid/view/View;
    move-result-object v4
    if-eqz v4, :nx
    return-object v4
    :nx
    add-int/lit8 v3, v3, 0x1
    goto :loop
    :no
    const/4 v0, 0x0
    return-object v0
.end method

.method static horiz(Landroid/view/View;)V
    .locals 8
    move-object v7, p0
    check-cast v7, Landroid/widget/LinearLayout;
    invoke-virtual {v7}, Landroid/widget/LinearLayout;->getOrientation()I
    move-result v0
    if-eqz v0, :o
    const/4 v0, 0x0
    invoke-virtual {v7, v0}, Landroid/widget/LinearLayout;->setOrientation(I)V
    :o
    invoke-virtual {p0}, Landroid/view/View;->getMinimumHeight()I
    move-result v0
    if-eqz v0, :mh
    const/4 v0, 0x0
    invoke-virtual {p0, v0}, Landroid/view/View;->setMinimumHeight(I)V
    :mh
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;
    move-result-object v0
    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v0
    iget v0, v0, Landroid/util/DisplayMetrics;->density:F
    const/high16 v1, 0x42400000
    mul-float/2addr v0, v1
    float-to-int v0, v0
    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    move-result-object v1
    if-eqz v1, :kids
    iget v2, v1, Landroid/view/ViewGroup$LayoutParams;->width:I
    const/4 v3, -0x1
    if-ne v2, v3, :setlp
    iget v2, v1, Landroid/view/ViewGroup$LayoutParams;->height:I
    if-eq v2, v0, :kids
    :setlp
    iput v3, v1, Landroid/view/ViewGroup$LayoutParams;->width:I
    iput v0, v1, Landroid/view/ViewGroup$LayoutParams;->height:I
    invoke-virtual {p0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    :kids
    invoke-virtual {v7}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v1
    const/4 v2, 0x0
    :loop
    if-ge v2, v1, :done
    invoke-virtual {v7, v2}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v3
    invoke-virtual {v3}, Landroid/view/View;->getVisibility()I
    move-result v4
    const/16 v5, 0x8
    if-ne v4, v5, :vis
    const/4 v4, 0x0
    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V
    :vis
    invoke-virtual {v3}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    move-result-object v4
    instance-of v5, v4, Landroid/widget/LinearLayout$LayoutParams;
    if-eqz v5, :next
    check-cast v4, Landroid/widget/LinearLayout$LayoutParams;
    iget v5, v4, Landroid/widget/LinearLayout$LayoutParams;->width:I
    if-nez v5, :fix
    iget v5, v4, Landroid/widget/LinearLayout$LayoutParams;->height:I
    const/4 v6, -0x1
    if-ne v5, v6, :fix
    iget v5, v4, Landroid/widget/LinearLayout$LayoutParams;->weight:F
    const/high16 v6, 0x3f800000
    cmpl-float v5, v5, v6
    if-eqz v5, :next
    :fix
    const/4 v5, 0x0
    iput v5, v4, Landroid/widget/LinearLayout$LayoutParams;->width:I
    const/4 v5, -0x1
    iput v5, v4, Landroid/widget/LinearLayout$LayoutParams;->height:I
    const/high16 v5, 0x3f800000
    iput v5, v4, Landroid/widget/LinearLayout$LayoutParams;->weight:F
    invoke-virtual {v3, v4}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    :next
    add-int/lit8 v2, v2, 0x1
    goto :loop
    :done
    return-void
.end method

.method static fix2(Landroid/view/View;)V
    .locals 12
    invoke-static {p0}, Lcom/zsplit/fb/FSplit;->findPager(Landroid/view/View;)Landroid/view/View;
    move-result-object v1
    if-eqz v1, :out
    const-string v0, "TabBarContainerLayout"
    const/4 v2, 0x0
    invoke-static {p0, v0, v2}, Lcom/zsplit/fb/FSplit;->findName(Landroid/view/View;Ljava/lang/String;I)Landroid/view/View;
    move-result-object v4
    if-eqz v4, :out
    instance-of v0, v4, Landroid/widget/LinearLayout;
    if-eqz v0, :out
    invoke-virtual {v1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;
    move-result-object v7
    instance-of v0, v7, Landroid/widget/FrameLayout;
    if-eqz v0, :out
    check-cast v7, Landroid/view/View;
    const v9, 0x7a5f0005
    move-object v0, v4
    check-cast v0, Landroid/widget/LinearLayout;
    invoke-virtual {v0}, Landroid/widget/LinearLayout;->getOrientation()I
    move-result v0
    const/4 v2, 0x1
    if-ne v0, v2, :chk
    sget-object v0, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;
    invoke-virtual {v4, v9, v0}, Landroid/view/View;->setTag(ILjava/lang/Object;)V
    :chk
    invoke-virtual {v4, v9}, Landroid/view/View;->getTag(I)Ljava/lang/Object;
    move-result-object v0
    if-eqz v0, :out
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v0
    invoke-static {v0}, Lcom/zsplit/fb/FSplit;->isWide(Landroid/content/Context;)Z
    move-result v8
    if-eqz v8, :nar
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I
    move-result v0
    invoke-static {v4, v0}, Lcom/zsplit/fb/FSplit;->compact(Landroid/view/View;I)V
    goto :geo
    :nar
    invoke-static {v4}, Lcom/zsplit/fb/FSplit;->horiz(Landroid/view/View;)V
    :geo
    const/4 v10, 0x2
    new-array v3, v10, [I
    new-array v5, v10, [I
    invoke-virtual {v4, v3}, Landroid/view/View;->getLocationInWindow([I)V
    invoke-virtual {v7, v5}, Landroid/view/View;->getLocationInWindow([I)V
    const/4 v0, 0x0
    aget v2, v3, v0
    aget v11, v5, v0
    sub-int/2addr v2, v11
    invoke-virtual {v4}, Landroid/view/View;->getWidth()I
    move-result v11
    add-int/2addr v2, v11
    const/4 v0, 0x1
    aget v6, v3, v0
    aget v11, v5, v0
    sub-int/2addr v6, v11
    if-eqz v8, :ngeo
    invoke-virtual {v4}, Landroid/view/View;->getWidth()I
    move-result v11
    invoke-static {v4, v11}, Lcom/zsplit/fb/FSplit;->header(Landroid/view/View;I)V
    goto :clamp
    :ngeo
    const/4 v2, 0x0
    invoke-virtual {v4}, Landroid/view/View;->getHeight()I
    move-result v11
    add-int/2addr v6, v11
    const/4 v11, 0x0
    const/4 v10, 0x0
    invoke-static {v10, v11}, Lcom/zsplit/fb/FSplit;->header(Landroid/view/View;I)V
    :clamp
    if-gez v2, :c1
    const/4 v2, 0x0
    :c1
    if-gez v6, :c2
    const/4 v6, 0x0
    :c2
    invoke-virtual {v1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    move-result-object v3
    instance-of v0, v3, Landroid/view/ViewGroup$MarginLayoutParams;
    if-eqz v0, :post
    check-cast v3, Landroid/view/ViewGroup$MarginLayoutParams;
    iget v0, v3, Landroid/view/ViewGroup$MarginLayoutParams;->leftMargin:I
    if-ne v0, v2, :set
    iget v0, v3, Landroid/view/ViewGroup$MarginLayoutParams;->topMargin:I
    if-eq v0, v6, :post
    :set
    iput v2, v3, Landroid/view/ViewGroup$MarginLayoutParams;->leftMargin:I
    iput v6, v3, Landroid/view/ViewGroup$MarginLayoutParams;->topMargin:I
    invoke-virtual {v1, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    :post
    invoke-static {v4, v1}, Lcom/zsplit/fb/FSplit;->bg(Landroid/view/View;Landroid/view/View;)V
    if-eqz v8, :out
    const/4 v11, 0x0
    invoke-static {v1, v11}, Lcom/zsplit/fb/FSplit;->unalpha(Landroid/view/View;I)V
    invoke-static {v4, v1}, Lcom/zsplit/fb/FSplit;->sync(Landroid/view/View;Landroid/view/View;)V
    invoke-static {v1}, Lcom/zsplit/fb/FSplit;->surfs(Landroid/view/View;)V
    :out
    return-void
.end method

.method static rebind(Landroid/view/View;I)V
    .locals 5
    instance-of v0, p0, Landroidx/recyclerview/widget/RecyclerView;
    if-eqz v0, :grp
    move-object v0, p0
    check-cast v0, Landroidx/recyclerview/widget/RecyclerView;
    invoke-virtual {v0}, Landroidx/recyclerview/widget/RecyclerView;->getAdapter()Landroidx/recyclerview/widget/RecyclerView$Adapter;
    move-result-object v1
    if-eqz v1, :rl
    invoke-virtual {v1}, Landroidx/recyclerview/widget/RecyclerView$Adapter;->notifyDataSetChanged()V
    :rl
    invoke-virtual {v0}, Landroid/view/View;->requestLayout()V
    return-void
    :grp
    instance-of v0, p0, Landroid/view/ViewGroup;
    if-eqz v0, :out
    const/16 v0, 0x14
    if-ge p1, v0, :out
    move-object v1, p0
    check-cast v1, Landroid/view/ViewGroup;
    invoke-virtual {v1}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v2
    add-int/lit8 v4, p1, 0x1
    const/4 v0, 0x0
    :loop
    if-ge v0, v2, :out
    invoke-virtual {v1, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v3
    invoke-static {v3, v4}, Lcom/zsplit/fb/FSplit;->rebind(Landroid/view/View;I)V
    add-int/lit8 v0, v0, 0x1
    goto :loop
    :out
    return-void
.end method

.method static refresh(Landroid/app/Activity;)V
    .locals 1
    :try_start
    if-eqz p0, :e
    invoke-static {p0}, LX/01Bu;->A04(Landroid/app/Activity;)V
    invoke-static {p0}, LX/01Bu;->A0A(Landroid/app/Activity;)Z
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :e
    :e
    return-void
.end method
