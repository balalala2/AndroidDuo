.class public final Lcom/zing/zalo/zsplit/ZTL;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public cls:Ljava/lang/Class;

.field public mgr:Lcom/zing/zalo/zview/b;

.field public pop:Z

.field public tab:I


# direct methods
.method public constructor <init>(Lcom/zing/zalo/zview/b;Ljava/lang/Class;IZ)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/zing/zalo/zsplit/ZTL;->mgr:Lcom/zing/zalo/zview/b;

    iput-object p2, p0, Lcom/zing/zalo/zsplit/ZTL;->cls:Ljava/lang/Class;

    iput p3, p0, Lcom/zing/zalo/zsplit/ZTL;->tab:I

    iput-boolean p4, p0, Lcom/zing/zalo/zsplit/ZTL;->pop:Z

    return-void
.end method


# virtual methods
.method public run()V
    .locals 12

    const/4 v0, -0x1

    :try_start_0
    iget-object v1, p0, Lcom/zing/zalo/zsplit/ZTL;->mgr:Lcom/zing/zalo/zview/b;

    if-nez v1, :cond_9

    sput v0, Lcom/zing/zalo/zsplit/ZSplit;->sPendTab:I

    return-void

    :cond_9
    iget-object v2, v1, Lcom/zing/zalo/zview/b;->d:Ljava/util/ArrayList;

    if-nez v2, :cond_11

    sput v0, Lcom/zing/zalo/zsplit/ZSplit;->sPendTab:I

    return-void

    :cond_11
    invoke-static {v2}, Lcom/zing/zalo/zsplit/ZSplit;->findMain(Ljava/util/ArrayList;)I

    move-result v3

    if-gez v3, :cond_1b

    sput v0, Lcom/zing/zalo/zsplit/ZSplit;->sPendTab:I

    return-void

    :cond_1b
    invoke-static {v2}, Lcom/zing/zalo/zsplit/ZSplit;->anyContext(Ljava/util/ArrayList;)Landroid/content/Context;

    move-result-object v4

    iget-boolean v5, p0, Lcom/zing/zalo/zsplit/ZTL;->pop:Z

    if-eqz v5, :cond_66

    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v5

    add-int/lit8 v5, v5, -0x1

    :goto_29
    if-le v5, v3, :cond_62

    invoke-virtual {v2, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Llio;

    if-eqz v6, :cond_5f

    iget-object v7, v6, Llio;->b:Lu1w;

    if-eqz v7, :cond_5f

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "POP["

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v9, "] "

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v9, v6, Llio;->a:Ljava/lang/Class;

    if-eqz v9, :cond_51

    invoke-virtual {v9}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v9

    goto :goto_53

    :cond_51
    const-string v9, "?"

    :goto_53
    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-static {v4, v8}, Lcom/zing/zalo/zsplit/ZSplit;->flog(Landroid/content/Context;Ljava/lang/String;)V

    const/4 v8, 0x0

    invoke-virtual {v1, v7, v8}, Lcom/zing/zalo/zview/b;->w0(Lu1w;I)Z

    :cond_5f
    add-int/lit8 v5, v5, -0x1

    goto :goto_29

    :cond_62
    sput v0, Lcom/zing/zalo/zsplit/ZSplit;->sPendTab:I

    return-void

    :cond_66
    iget-object v6, p0, Lcom/zing/zalo/zsplit/ZTL;->cls:Ljava/lang/Class;

    if-nez v6, :cond_6e

    sput v0, Lcom/zing/zalo/zsplit/ZSplit;->sPendTab:I

    return-void

    :cond_6e
    iget v5, p0, Lcom/zing/zalo/zsplit/ZTL;->tab:I

    const/4 v7, 0x1

    if-ne v5, v7, :cond_a2

    const-string v8, "204278670"

    invoke-static {v8, v7}, Lu0k;->g(Ljava/lang/String;Z)Lcom/zing/zalo/control/ContactProfile;

    move-result-object v9

    if-nez v9, :cond_82

    new-instance v9, Lcom/zing/zalo/control/ContactProfile;

    invoke-direct {v9, v8}, Lcom/zing/zalo/control/ContactProfile;-><init>(Ljava/lang/String;)V

    :cond_82
    new-instance v10, Lvp4;

    invoke-direct {v10, v8}, Lvp4;-><init>(Ljava/lang/String;)V

    invoke-virtual {v10, v9}, Lvp4;->c(Lcom/zing/zalo/control/ContactProfile;)V

    invoke-virtual {v10}, Lvp4;->a()Landroid/os/Bundle;

    move-result-object v7

    if-nez v7, :cond_95

    new-instance v7, Landroid/os/Bundle;

    invoke-direct {v7}, Landroid/os/Bundle;-><init>()V

    :cond_95
    const-string v8, "STR_SOURCE_START_VIEW"

    const-string v9, "chats_list_button_plus"

    invoke-virtual {v7, v8, v9}, Landroid/os/BaseBundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_a7

    :cond_a2
    new-instance v7, Landroid/os/Bundle;

    invoke-direct {v7}, Landroid/os/Bundle;-><init>()V

    :goto_a7
    const-string v8, "SHOW_WITH_FLAGS"

    const/high16 v9, 0x700000

    invoke-virtual {v7, v8, v9}, Landroid/os/BaseBundle;->putInt(Ljava/lang/String;I)V

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "PUSH tab="

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v9, " cls="

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v9, " stack="

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v2}, Lcom/zing/zalo/zsplit/ZSplit;->desc(Ljava/util/ArrayList;)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-static {v4, v8}, Lcom/zing/zalo/zsplit/ZSplit;->flog(Landroid/content/Context;Ljava/lang/String;)V

    move-object v5, v1

    const/4 v8, 0x0

    const/4 v9, 0x0

    const/4 v10, 0x0

    const/4 v11, 0x1

    invoke-virtual/range {v5 .. v11}, Lcom/zing/zalo/zview/b;->R0(Ljava/lang/Class;Landroid/os/Bundle;ILjava/lang/String;IZ)V

    sput v0, Lcom/zing/zalo/zsplit/ZSplit;->sPendTab:I
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_e6

    return-void

    :catch_e6
    move-exception v1

    sput v0, Lcom/zing/zalo/zsplit/ZSplit;->sPendTab:I

    const-string v2, "ZDuo"

    const-string v3, "ZTL run failed"

    invoke-static {v2, v3, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method
