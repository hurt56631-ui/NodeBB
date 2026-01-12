<li component="chat/message" class="chat-message-item {{{ if messages.self }}}self-message{{{ else }}}other-message{{{ end }}}" data-mid="{messages.messageId}" data-uid="{messages.fromuid}" data-self="{messages.self}">
    <div class="message-container">
        <!-- 头像 -->
        <div class="message-avatar">
            <a href="{config.relative_path}/user/{messages.fromUser.userslug}">
                {buildAvatar(messages.fromUser, "45px", true, "not-responsive")}
            </a>
        </div>

        <!-- 内容 -->
        <div class="message-content">
            {{{ if !messages.self }}}
            <div class="chat-user-name text-muted">{messages.fromUser.displayname}</div>
            {{{ end }}}
            
            <div class="bubble-wrapper">
                <div component="chat/message/body" class="message-bubble">
                    {messages.content}
                </div>
                <!-- 翻译按钮 -->
                <div class="ai-translate-icon" onclick="runAiTranslate('{messages.messageId}')">
                    <i class="fa fa-language"></i>
                </div>
            </div>
            <div id="trans-{messages.messageId}" class="translation-res"></div>
        </div>
    </div>
</li>
