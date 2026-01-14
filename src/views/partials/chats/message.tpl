<li component="chat/message" class="chat-message w-100 mb-1 {{{ if messages.deleted }}} deleted{{{ end }}} {{{ if messages.pinned}}} pinned{{{ end }}} {{{ if messages.self }}}self justify-content-end{{{ else }}}justify-content-start{{{ end }}}" data-mid="{messages.messageId}" data-uid="{messages.fromuid}" data-self="{messages.self}" data-timestamp="{messages.timestamp}" style="display: flex; position: relative;">

	{{{ if messages.parent }}}
	<!-- IMPORT partials/chats/parent.tpl -->
	{{{ end }}}

    <!-- 1. 头像区域 (仅他人显示，自己不显示) -->
    {{{ if !messages.self }}}
    <div class="chat-avatar-wrapper me-2" style="flex-shrink: 0;">
        <a href="{config.relative_path}/user/{messages.fromUser.userslug}" class="text-decoration-none">
            {buildAvatar(messages.fromUser, "42px", true, "not-responsive")}
            <!-- 国旗容器 -->
            <span class="country-flag" data-uid="{messages.fromuid}"></span>
        </a>
    </div>
    {{{ end }}}

    <!-- 2. 内容区域 -->
    <div class="message-content-wrapper" style="max-width: 75%; display: flex; flex-direction: column; {{{ if messages.self }}}align-items: flex-end;{{{ else }}}align-items: flex-start;{{{ end }}}">
        
        <!-- 用户名 (仅他人显示) -->
        {{{ if !messages.self }}}
        <div class="message-header text-muted small lh-1 mb-1 {{{ if !messages.newSet }}}hidden{{{ end }}}">
            <span class="fw-bold">{messages.fromUser.displayname}</span>
            <span class="timeago ms-1" style="font-size: 10px;" title="{messages.timestampISO}"></span>
        </div>
        {{{ end }}}

        <!-- 消息气泡 -->
        <div class="message-body-container position-relative">
            <div component="chat/message/body" class="message-body px-3 py-2 text-break shadow-sm" oncontextmenu="return false;">
                {messages.content}
            </div>

            <!-- 控制栏 (TTS, 回复, 改错) -->
            <div class="message-controls mt-1">
                <div class="d-flex align-items-center gap-2 bg-light rounded-pill px-2 py-1 border">
                    <!-- TTS 朗读 -->
                    <i class="fa fa-volume-up tts-icon cursor-pointer text-secondary" onclick="window.chatTTS(this, '{messages.contentRaw}')" title="朗读"></i>
                    
                    <!-- 改错 (模拟 HelloTalk) -->
                    <i class="fa fa-pencil-square-o cursor-pointer text-success" onclick="window.chatCorrect('{messages.fromUser.username}', '{messages.contentRaw}')" title="改错"></i>

                    <!-- 回复 -->
                    <i class="fa fa-reply cursor-pointer text-primary" onclick="window.chatReply(this)" title="回复"></i>

                    <!-- 更多菜单 (撤回等) -->
                    <div class="dropdown d-inline-block">
                        <i class="fa fa-ellipsis-h cursor-pointer text-secondary" data-bs-toggle="dropdown"></i>
                        <ul class="dropdown-menu dropdown-menu-end p-1 shadow-sm text-sm">
                            {{{ if (isAdminOrGlobalMod || (!config.disableChatMessageEditing && messages.self)) }}}
                            <li><a href="#" class="dropdown-item text-danger rounded" data-action="delete"><i class="fa fa-trash me-2"></i> 撤回消息</a></li>
                            <li><a href="#" class="dropdown-item rounded" data-action="edit"><i class="fa fa-edit me-2"></i> 编辑</a></li>
                            {{{ end }}}
                            <li><a href="#" class="dropdown-item rounded" data-action="copy-link" data-mid="{messages.mid}"><i class="fa fa-link me-2"></i> 复制链接</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 脚本：功能逻辑 -->
    <script>
    (function() {
        // --- 1. 国旗逻辑 ---
        const uid = "{messages.fromuid}";
        const mid = "{messages.messageId}";
        if (!window.flagCache) window.flagCache = {};

        // 只有他人消息才找国旗元素
        const flagEl = document.querySelector(`.chat-message[data-mid="${mid}"] .country-flag`);
        
        if (flagEl) {
            if (window.flagCache[uid]) {
                renderFlag(flagEl, window.flagCache[uid]);
            } else {
                // 获取用户资料
                fetch(config.relative_path + '/api/user/' + uid)
                    .then(r => r.json())
                    .then(d => {
                        const loc = d.location || d.userData?.location || '';
                        window.flagCache[uid] = loc;
                        renderFlag(flagEl, loc);
                    });
            }
        }

        function renderFlag(el, loc) {
            if (!loc) return;
            // 简单关键词匹配国旗，你可以自己加更多
            const map = {'China': '🇨🇳', 'CN': '🇨🇳', '中国': '🇨🇳', 'US': '🇺🇸', 'UK': '🇬🇧', 'Japan': '🇯🇵'};
            let icon = '';
            for(let k in map) { if(loc.includes(k)) icon = map[k]; }
            if(icon) { el.innerHTML = icon; el.style.display = 'block'; }
        }

        // --- 2. 全局功能函数注册 ---
        
        // TTS
        if (!window.chatTTS) {
            window.chatTTS = function(btn, text) {
                if (!text) return;
                const icon = btn;
                
                // 停止逻辑
                if (window.currentAudio && !window.currentAudio.paused) {
                    window.currentAudio.pause();
                    window.currentAudio = null;
                    document.querySelectorAll('.tts-icon').forEach(i => i.className = 'fa fa-volume-up tts-icon cursor-pointer text-secondary');
                    return;
                }

                icon.className = 'fa fa-spinner fa-spin text-primary';
                
                const url = `https://t.leftsite.cn/tts?t=${encodeURIComponent(text)}&v=zh-CN-XiaoxiaoMultilingualNeural&r=0`;
                const audio = new Audio(url);
                window.currentAudio = audio;

                audio.oncanplaythrough = () => { 
                    audio.play(); 
                    icon.className = 'fa fa-stop-circle text-danger cursor-pointer'; 
                };
                audio.onended = () => { icon.className = 'fa fa-volume-up tts-icon cursor-pointer text-secondary'; };
                audio.onerror = () => { icon.className = 'fa fa-exclamation-triangle text-warning'; };
            };
        }

        // 改错 (HelloTalk 风格)
        if (!window.chatCorrect) {
            window.chatCorrect = function(username, rawText) {
                require(['composer'], function(composer) {
                    const tid = ajaxify.data.tid;
                    const text = `> ${rawText}\n\n修改：\n~~错误~~ **正确**`;
                    composer.newReply(tid, undefined, text);
                });
            };
        }

        // 回复
        if (!window.chatReply) {
            window.chatReply = function(username) {
                require(['composer'], function(composer) {
                    const tid = ajaxify.data.tid;
                    composer.newReply(tid, undefined, '@' + username + ' ');
                });
            };
        }

    })();
    </script>
</li>
