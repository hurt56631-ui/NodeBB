<li component="chat/message" class="im-message-row {{{ if messages.deleted }}}deleted{{{ end }}}" 
    data-mid="{messages.messageId}" 
    data-self="{messages.self}" 
    data-timestamp="{messages.timestamp}"
    data-break="{messages.newSet}">

    <!-- 1. 微信式时间显示 (JS控制内容，默认隐藏) -->
    <div class="im-system-time-container d-none">
        <span class="im-system-time badge bg-light text-secondary"></span>
    </div>

    <!-- 2. 消息主体容器 (自己反转布局) -->
    <div class="im-message-body d-flex w-100 mb-2 {{{ if messages.self }}}flex-row-reverse align-items-start{{{ else }}}align-items-start{{{ end }}}">

        <!-- 3. 头像区域 -->
        <div class="im-avatar-wrapper {{{ if messages.self }}}ms-2{{{ else }}}me-2{{{ end }}}">
            {{{ if messages.newSet }}}
                <!-- 新的一组对话，显示头像 -->
                <a href="{config.relative_path}/user/{messages.fromUser.userslug}">
                    {buildAvatar(messages.fromUser, "50px", true, "im-chat-avatar shadow-sm")}
                </a>
            {{{ else }}}
                <!-- 连续发言，显示透明占位符保持对齐 -->
                <div class="im-chat-avatar-placeholder" style="width: 50px; height: 50px;"></div>
            {{{ end }}}
        </div>

        <!-- 4. 气泡与内容 -->
        <div class="im-content-wrapper d-flex flex-column {{{ if messages.self }}}align-items-end{{{ else }}}align-items-start{{{ end }}}" style="max-width: 75%;">
            
            <!-- 气泡本体 -->
            <div component="chat/message/body" 
                 class="im-bubble shadow-sm position-relative p-3 {{{ if messages.self }}}im-bubble-self{{{ else }}}im-bubble-other bg-white{{{ end }}}">
                
                <!-- 消息内容 -->
                <div class="im-text-content text-break">
                    {messages.content}
                </div>

                <!-- 消息状态/极小的时间 (可选，类似Telegram右下角时间) -->
                <!-- 如果完全像微信，可以不要这个，只保留顶部的系统时间 -->
            </div>
            
            <!-- 原生时间戳隐藏，我们用上面的 System Time -->
        </div>
    </div>
</li>
