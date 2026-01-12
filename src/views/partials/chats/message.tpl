<li component="chat/message" class="chat-app-message {{{ if messages.self }}}self{{{ else }}}other{{{ end }}}" 
    data-mid="{messages.messageId}" data-uid="{messages.fromuid}" data-timestamp="{messages.timestamp}">

    <div class="message-inner">
        <!-- 1. 头像与国家国旗 -->
        <div class="message-avatar-col">
            {{{ if messages.newSet }}}
            <div class="avatar-wrapper">
                <a href="{config.relative_path}/user/{messages.fromUser.userslug}">
                    {buildAvatar(messages.fromUser, "45px", true, "not-responsive")}
                </a>
                <!-- 使用 flagpedia 提供的真实国旗图片，这里后期可根据用户数据字段动态替换 countryCode -->
                <img src="https://flagcdn.com/w40/cn.png" class="real-national-flag" /> 
            </div>
            {{{ end }}}
        </div>

        <div class="message-main-col">
            <!-- 2. 引用回复 (去掉符号，仅保留背景文字) -->
            {{{ if messages.parent }}}
            <div class="app-reply-box">
                {messages.parent.content}
            </div>
            {{{ end }}}

            <!-- 3. 气泡区 (支持长按) -->
            <div class="bubble-container">
                <div component="chat/message/body" class="chat-app-bubble">
                    {messages.content}
                </div>

                <!-- 4. 隐藏式长按菜单 (App 风格) -->
                <div class="app-action-menu">
                    <div class="menu-tab" onclick="runAiTranslate('{messages.messageId}')"><i class="fa fa-language"></i> 翻译</div>
                    <div class="menu-tab" onclick="startCorrection('{messages.messageId}')"><i class="fa fa-check-square-o"></i> 纠错</div>
                    <div class="menu-tab" data-action="reply"><i class="fa fa-reply"></i> 引用</div>
                    {{{ if messages.self }}}
                    <div class="menu-tab text-danger" data-action="delete"><i class="fa fa-trash"></i> 撤回</div>
                    {{{ end }}}
                </div>
            </div>
            <div id="trans-{messages.messageId}" class="translation-area"></div>
        </div>
    </div>
</li>
