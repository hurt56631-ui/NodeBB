<!-- BEGIN messages -->
<li component="chat/message" class="chat-message {{{ if messages.self }}}self{{{ end }}}" data-mid="{messages.messageId}" data-uid="{messages.fromUser.uid}">
    <div style="display: flex; align-items: flex-start; padding: 10px;">
        <!-- 头像 -->
        <a href="{config.relative_path}/user/{messages.fromUser.userslug}">
            {buildAvatar(messages.fromUser, "40px", true, "not-responsive")}
        </a>
        
        <div style="margin-left: 10px;">
            <!-- 用户名 -->
            <a href="{config.relative_path}/user/{messages.fromUser.userslug}">
                <strong>{messages.fromUser.displayname}</strong>
            </a>
            
            <!-- 消息内容 -->
            <div component="chat/message/body" style="color: #333; background-color: #f0f0f0; padding: 8px; border-radius: 8px; margin-top: 4px;">
                {messages.content}
            </div>
        </div>
    </div>
</li>
<!-- END messages -->
