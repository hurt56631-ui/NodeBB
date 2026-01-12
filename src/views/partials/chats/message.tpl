<li component="chat/message" class="chat-app-message {{{ if messages.self }}}self{{{ else }}}other{{{ end }}}" 
    data-mid="{messages.messageId}" data-uid="{messages.fromuid}" data-timestamp="{messages.timestamp}">

    <div class="message-inner-flex">
        <!-- 1. 圆形头像 + 小国旗 -->
        <div class="avatar-col">
            {{{ if messages.newSet }}}
            <div class="avatar-box">
                <a href="{config.relative_path}/user/{messages.fromUser.userslug}">
                    {buildAvatar(messages.fromUser, "45px", true, "not-responsive")}
                </a>
                <img src="https://flagcdn.com/w40/cn.png" class="mini-flag" /> 
            </div>
            {{{ end }}}
        </div>

        <!-- 2. 消息主体 -->
        <div class="message-content-col">
            <div class="bubble-rel-wrapper">
                <!-- 气泡本体 -->
                <div component="chat/message/body" class="chat-bubble-main">
                    {messages.content}
                </div>

                <!-- 3. 长按菜单 (绝对定位，默认隐藏) -->
                <div class="app-longpress-menu">
                    <div class="menu-item" onclick="runAiTranslate('{messages.messageId}')"><i class="fa fa-language"></i><span>翻译</span></div>
                    <div class="menu-item" onclick="startCorrection('{messages.messageId}')"><i class="fa fa-check-square-o"></i><span>纠错</span></div>
                    <div class="menu-item" data-action="reply"><i class="fa fa-reply"></i><span>引用</span></div>
                    {{{ if messages.self }}}
                    <div class="menu-item text-danger" data-action="delete"><i class="fa fa-trash"></i><span>撤回</span></div>
                    {{{ end }}}
                </div>
            </div>
        </div>
    </div>
</li>
