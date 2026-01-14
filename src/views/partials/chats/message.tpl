<li component="chat/message" class="chat-app-message {{{ if messages.self }}}self{{{ else }}}other{{{ end }}} {{{ if !messages.newSet }}}continued-message{{{ end }}}" 
    data-mid="{messages.messageId}" data-uid="{messages.fromuid}" data-timestamp="{messages.timestamp}">

    <div class="message-inner-flex">
        <!-- 1. 圆形头像 + 小国旗 -->
        <div class="avatar-col">
            {{{ if messages.newSet }}}
            <div class="avatar-box">
                <a href="{config.relative_path}/user/{messages.fromUser.userslug}">
                    {buildAvatar(messages.fromUser, "45px", true, "not-responsive")}
                </a>
                <!-- 根据用户“国籍 (nationality)”字段显示国旗 -->
                {{{ if messages.fromUser.customFields.nationality }}}
                <img src="https://flagcdn.com/w20/{messages.fromUser.customFields.nationality | toLowerCase}.png" class="mini-flag" />
                {{{ end }}}
            </div>
            {{{ else }}}
            <div class="avatar-placeholder"></div>
            {{{ end }}}
        </div>

        <!-- 2. 消息主体 -->
        <div class="message-content-col">
            <!-- 引用回复区域：只有当存在父消息时才显示 -->
            {{{ if messages.parent }}}
            <div class="app-quote-box" onclick="scrollToMessage('{messages.parent.mid}')" style="cursor: pointer;">
                <div class="quote-header">
                    <i class="fa fa-reply text-muted"></i>
                    <span class="quote-username fw-semibold">{messages.parent.user.displayname}</span>
                </div>
                <div class="quote-content text-truncate">{messages.parent.content}</div>
            </div>
            {{{ end }}}
            
            <!-- 消息气泡与长按菜单 -->
            <div class="bubble-rel-wrapper">
                <div component="chat/message/body" class="chat-bubble-main">
                    {messages.content}
                </div>
                
                <!-- 长按菜单 -->
                <div class="app-longpress-menu">
                    <div class="menu-item" onclick="runAiTranslate('{messages.messageId}')">
                        <i class="fa fa-language"></i><span>翻译</span>
                    </div>
                    <div class="menu-item" onclick="startCorrection('{messages.messageId}')">
                        <i class="fa fa-check-square-o"></i><span>纠错</span>
                    </div>
                    <div class="menu-item" data-action="reply" data-mid="{messages.messageId}">
                        <i class="fa fa-reply"></i><span>引用</span>
                    </div>
                    {{{ if messages.self }}}
                    <div class="menu-item text-danger" data-action="delete">
                        <i class="fa fa-trash"></i><span>撤回</span>
                    </div>
                    {{{ end }}}
                </div>
            </div>
        </div>
    </div>
</li>
