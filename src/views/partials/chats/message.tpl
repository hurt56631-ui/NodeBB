<li component="chat/message" class="chat-message-item {{{ if messages.self }}}self-message{{{ else }}}other-message{{{ end }}}" data-mid="{messages.messageId}" data-uid="{messages.fromuid}" data-self="{messages.self}">
    
    <div class="message-container d-flex">
        <!-- 1. 头像区 (电报风格) -->
        <div class="message-avatar-box">
            <a href="{config.relative_path}/user/{messages.fromUser.userslug}" class="avatar-link">
                {buildAvatar(messages.fromUser, "45px", true, "not-responsive")}
            </a>
        </div>

        <!-- 2. 内容区 -->
        <div class="message-content-wrapper d-flex flex-column">
            <!-- 只有对方发消息时才显示名字 -->
            {{{ if !messages.self }}}
            <span class="chat-user-name">{messages.fromUser.displayname}</span>
            {{{ end }}}

            <div class="bubble-and-actions d-flex align-items-end">
                <!-- 消息气泡 -->
                <div component="chat/message/body" class="message-bubble">
                    {messages.content}
                </div>

                <!-- 紫色 AI 翻译按钮 -->
                <div class="ai-translate-btn" onclick="runAiTranslate('{messages.messageId}')" title="AI翻译">
                    <i class="fa fa-language"></i>
                </div>
            </div>
            
            <!-- 翻译结果显示区 -->
            <div class="translation-result-area" id="trans-{messages.messageId}"></div>
        </div>
    </div>
</li>
