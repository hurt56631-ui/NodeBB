<li component="chat/message" class="chat-message mx-2 pe-2 {{{ if messages.deleted }}} deleted{{{ end }}} {{{ if messages.pinned}}} pinned{{{ end }}} {{{ if messages.newSet }}}new-set pt-3{{{ end }}} {{{ if messages.self }}}self{{{ end }}}" data-mid="{messages.messageId}" data-uid="{messages.fromuid}" data-index="{messages.index}" data-self="{messages.self}" data-break="{messages.newSet}" data-timestamp="{messages.timestamp}" data-username="{messages.fromUser.username}" data-displayname="{messages.fromUser.displayname}">

	{{{ if messages.parent }}}
	<!-- IMPORT partials/chats/parent.tpl -->
	{{{ end }}}

    <!-- 1. 头像区域 (Avatar) -->
    <div class="chat-avatar-wrapper">
        <a href="{config.relative_path}/user/{messages.fromUser.userslug}" class="text-decoration-none avatar-link">
            <!-- 强制圆形头像 -->
            {buildAvatar(messages.fromUser, "48px", true, "not-responsive")}
            
            <!-- 在线状态 (右上角) -->
            <span class="status-dot {{{ if messages.fromUser.status }}}status-{messages.fromUser.status}{{{ end }}}"></span>
            
            <!-- 国旗 (示例：由于NodeBB默认不传国家数据，这里放一个占位符，需插件支持) -->
            <i class="fa fa-flag flag-icon" style="display:none;"></i> 
        </a>
    </div>

    <!-- 2. 内容区域 -->
    <div class="message-content-wrapper">
        
        <!-- 用户名与时间 (仅他人消息显示) -->
        <div class="message-header lh-1 d-flex align-items-center gap-2 text-sm {{{ if !messages.newSet }}}hidden-name{{{ end }}} pb-1">
            <span class="chat-user fw-semibold">
                <a href="{config.relative_path}/user/{messages.fromUser.userslug}">{messages.fromUser.displayname}</a>
            </span>
            <span class="chat-timestamp text-muted timeago" title="{messages.timestampISO}"></span>
        </div>

        <!-- 消息气泡与控制栏 -->
        <div class="message-body-container position-relative">
            <!-- 消息正文 -->
            <div component="chat/message/body" class="message-body px-3 py-2 overflow-auto text-break" oncontextmenu="return false;">
                {messages.content}
            </div>

            <!-- 反应 (Reactions) -->
            <!-- IMPORT partials/chats/reactions.tpl -->

            <!-- 控制按钮组 (Controls) -->
            <div component="chat/message/controls" class="message-controls">
                <div class="btn-group shadow-sm controls-group bg-body">
                    <!-- TTS 朗读按钮 -->
                    <button class="btn btn-sm btn-link tts-btn" type="button" onclick="playTTS(this)" data-text="{messages.contentRaw}">
                        <i class="fa fa-volume-up"></i>
                    </button>

                    <!-- 回复 -->
                    <button class="btn btn-sm btn-link" data-action="reply" title="[[topic:reply]]"><i class="fa fa-reply"></i></button>

                    <!-- 更多菜单 -->
                    <div class="btn-group d-inline-block">
                        <button class="btn btn-sm btn-link dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fa fa-ellipsis-h"></i></button>
                        <ul class="dropdown-menu dropdown-menu-end p-1 text-sm list-unstyled custom-context-menu" role="menu">
                            
                            {{{ if (isAdminOrGlobalMod || (!config.disableChatMessageEditing && messages.self)) }}}
                            <li>
                                <a href="#" class="dropdown-item rounded-1" data-action="edit" role="menuitem"><i class="fa fa-pencil text-muted me-2"></i> 改错/编辑</a>
                            </li>
                            <li>
                                <!-- 将删除重命名为撤回 -->
                                <a href="#" class="dropdown-item rounded-1 text-danger" data-action="delete" role="menuitem"><i class="fa fa-trash text-danger me-2"></i> 撤回消息</a>
                            </li>
                            {{{ end }}}

                            <li>
                                <a href="#" class="dropdown-item rounded-1" data-action="copy-text" data-mid="{messages.mid}" role="menuitem"><i class="fa fa-copy text-muted me-2"></i> 复制</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 嵌入式脚本：处理 TTS 和 菜单屏蔽 -->
    <script>
    (function() {
        // 1. 屏蔽浏览器默认右键菜单 (针对聊天气泡)
        var bubbles = document.querySelectorAll('.message-body');
        bubbles.forEach(function(b) {
            b.addEventListener('contextmenu', function(e) {
                e.preventDefault();
                // 这里可以触发自定义的长按逻辑，目前先屏蔽浏览器菜单
                return false;
            }, false);
        });
    })();

    // 2. TTS 朗读函数
    function playTTS(btn) {
        var text = btn.getAttribute('data-text');
        if (!text) return;
        
        // 防止重复点击
        if (btn.classList.contains('playing')) return;
        btn.classList.add('playing');
        btn.innerHTML = '<i class="fa fa-spinner fa-spin"></i>';

        // 构建 API URL
        var voice = 'zh-CN-XiaoxiaoMultilingualNeural';
        var url = 'https://t.leftsite.cn/tts?t=' + encodeURIComponent(text) + '&v=' + voice;

        var audio = new Audio(url);
        audio.play().catch(function(err) {
            console.error('TTS Error:', err);
            alert('朗读失败，请检查网络或接口');
        });

        audio.onended = function() {
            btn.classList.remove('playing');
            btn.innerHTML = '<i class="fa fa-volume-up"></i>';
        };
        
        audio.onerror = function() {
            btn.classList.remove('playing');
            btn.innerHTML = '<i class="fa fa-exclamation-triangle"></i>';
        };
    }
    </script>
</li>
