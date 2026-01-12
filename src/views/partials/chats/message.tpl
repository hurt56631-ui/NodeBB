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
                <!-- 根据用户“国籍 (nationality)”字段显示国旗，如果为空则不显示 -->
                {{{ if messages.fromUser.customFields.nationality }}}
                <img src="https://flagcdn.com/w20/{messages.fromUser.customFields.nationality | toLowerCase}.png" class="mini-flag" />
                {{{ end }}}
            </div>
            {{{ else }}}
            <!-- 连续发言时留出空白占位，保持对齐 -->
            <div class="avatar-placeholder"></div>
            {{{ end }}}
        </div>

        <!-- 2. 消息主体 -->
        <div class="message-content-col">
            <!-- 引用回复 (修复版) -->
            {{{ if messages.parent }}}
            <div class="app-quote-box">
                <!-- IMPORT partials/chats/parent.tpl -->
            </div>
            {{{ end }}}
            
            <div class="bubble-rel-wrapper">
                <div component="chat/message/body" class="chat-bubble-main">
                    {messages.content}
                </div>
                
                <!-- 长按菜单 (绝对定位，默认隐藏) -->
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
