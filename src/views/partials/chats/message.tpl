<li component="chat/message" class="chat-message-item {{{ if messages.self }}}self-message{{{ else }}}other-message{{{ end }}}" data-mid="{messages.messageId}" data-uid="{messages.fromuid}">
    <div class="message-inner-container">
        <!-- 头像 (对方显示，自己显示) -->
        <div class="chat-avatar-wrapper">
            {buildAvatar(messages.fromUser, "45px", true, "not-responsive")}
        </div>

        <div class="chat-content-main">
            <!-- 气泡上方只在对方发时显示名字 -->
            {{{ if !messages.self }}}
            <div class="chat-username">{messages.fromUser.displayname}</div>
            {{{ end }}}

            <div class="chat-bubble-row">
                <div component="chat/message/body" class="chat-bubble-body">
                    {messages.content}
                </div>
                <!-- AI 翻译图标 -->
                <div class="ai-translate-mini-btn" onclick="runAiTranslate('{messages.messageId}')">
                    <i class="fa fa-language"></i>
                </div>
            </div>
            <div id="trans-{messages.messageId}" class="translation-text-box"></div>
        </div>
    </div>
</li>
