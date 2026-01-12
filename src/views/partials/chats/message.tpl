<li component="chat/message" class="chat-app-message {{{ if messages.self }}}self{{{ else }}}other{{{ end }}} {{{ if messages.newSet }}}new-group{{{ end }}}" 
    data-mid="{messages.messageId}" data-uid="{messages.fromuid}" data-timestamp="{messages.timestamp}">

    <div class="message-inner">
        <!-- 1. 头像区 -->
        <div class="message-avatar-container">
            {{{ if messages.newSet }}}
            <a href="{config.relative_path}/user/{messages.fromUser.userslug}">
                {buildAvatar(messages.fromUser, "48px", true, "not-responsive")}
            </a>
            {{{ end }}}
        </div>

        <!-- 2. 内容区 -->
        <div class="message-main">
            <!-- 名字（仅对方显示） -->
            {{{ if !messages.self }}}
                {{{ if messages.newSet }}}
                <div class="chat-user-displayname">{messages.fromUser.displayname}</div>
                {{{ end }}}
            {{{ end }}}

            <div class="bubble-actions-row">
                <!-- 气泡本体 -->
                <div class="chat-bubble-content">
                    {{{ if messages.parent }}}
                    <div class="quote-reply">
                        <i class="fa fa-reply"></i> {messages.parent.content}
                    </div>
                    {{{ end }}}

                    <div component="chat/message/body" class="message-text">
                        {messages.content}
                    </div>
                </div>

                <!-- 3. 侧边快捷功能（紫色AI按钮、改错、撤回） -->
                <div class="side-action-buttons">
                    <!-- AI 翻译（标志性紫色圆圈） -->
                    <div class="purple-ai-btn" onclick="runAiTranslate('{messages.messageId}')">
                        <i class="fa fa-language"></i>
                    </div>

                    {{{ if messages.self }}}
                    <!-- 改错 (编辑) -->
                    <div class="action-item" data-action="edit"><i class="fa fa-pencil"></i></div>
                    <!-- 撤回 (删除) -->
                    <div class="action-item" data-action="delete"><i class="fa fa-trash"></i></div>
                    {{{ end }}}
                </div>
            </div>

            <!-- 翻译结果显示 -->
            <div id="trans-{messages.messageId}" class="ai-translation-res"></div>
        </div>
    </div>
</li>
