<li component="chat/message" class="chat-app-message {{{ if messages.self }}}self{{{ else }}}other{{{ end }}}" 
    data-mid="{messages.messageId}" data-uid="{messages.fromuid}" data-timestamp="{messages.timestamp}">

    <div class="message-inner">
        <!-- 1. 头像区 (圆形 + 国旗) -->
        <div class="message-avatar-col">
            {{{ if messages.newSet }}}
            <div class="avatar-wrapper">
                <a href="{config.relative_path}/user/{messages.fromUser.userslug}">
                    {buildAvatar(messages.fromUser, "45px", true, "not-responsive")}
                </a>
                <!-- 如果用户有位置信息则显示国旗(需配合插件或填入固定样式) -->
                <span class="user-flag">🚩</span> 
            </div>
            {{{ end }}}
        </div>

        <!-- 2. 气泡区 -->
        <div class="message-body-col">
            <div class="bubble-and-menu">
                <!-- 引用回复 (美化版) -->
                {{{ if messages.parent }}}
                <div class="reply-quote">
                    <i class="fa fa-reply"></i> {messages.parent.content}
                </div>
                {{{ end }}}

                <!-- 气泡本体 (增加触控反馈) -->
                <div component="chat/message/body" class="chat-bubble">
                    {messages.content}
                </div>

                <!-- 3. 长按弹出的菜单 (默认隐藏) -->
                <div class="app-context-menu">
                    <div class="menu-item" onclick="runAiTranslate('{messages.messageId}')"><i class="fa fa-language"></i> 翻译</div>
                    <div class="menu-item" data-action="reply"><i class="fa fa-reply"></i> 引用</div>
                    {{{ if messages.self }}}
                    <div class="menu-item" data-action="edit"><i class="fa fa-pencil"></i> 改错</div>
                    <div class="menu-item text-danger" data-action="delete"><i class="fa fa-trash"></i> 撤回</div>
                    {{{ end }}}
                </div>
            </div>

            <!-- 翻译结果 -->
            <div id="trans-{messages.messageId}" class="ai-res-box"></div>
        </div>
    </div>
</li>
