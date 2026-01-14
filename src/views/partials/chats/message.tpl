<li component="chat/message" class="chat-message mx-2 pe-2 {{{ if messages.deleted }}} deleted{{{ end }}} {{{ if messages.pinned}}} pinned{{{ end }}} {{{ if messages.newSet }}}new-set pt-3{{{ end }}} {{{ if messages.self }}}self{{{ end }}}" data-mid="{messages.messageId}" data-uid="{messages.fromuid}" data-index="{messages.index}" data-self="{messages.self}" data-break="{messages.newSet}" data-timestamp="{messages.timestamp}" data-username="{messages.fromUser.username}">

	{{{ if messages.parent }}}
	<!-- IMPORT partials/chats/parent.tpl -->
	{{{ end }}}

    <!-- 1. 头像区域 -->
    <div class="chat-avatar-wrapper">
        <a href="{config.relative_path}/user/{messages.fromUser.userslug}" class="text-decoration-none avatar-link">
            {buildAvatar(messages.fromUser, "48px", true, "not-responsive")}
            <span class="status-dot {{{ if messages.fromUser.status }}}status-{messages.fromUser.status}{{{ end }}}"></span>
            
            <!-- 国旗容器：通过 JS 动态填充 -->
            <span class="country-flag" data-uid="{messages.fromuid}"></span>
        </a>
    </div>

    <!-- 2. 内容区域 -->
    <div class="message-content-wrapper">
        
        <!-- 用户名 (仅他人消息显示) -->
        <div class="message-header lh-1 d-flex align-items-center gap-2 text-sm {{{ if !messages.newSet }}}hidden-name{{{ end }}} pb-1">
            <span class="chat-user fw-semibold">
                <a href="{config.relative_path}/user/{messages.fromUser.userslug}">{messages.fromUser.displayname}</a>
            </span>
            <span class="chat-timestamp text-muted timeago" title="{messages.timestampISO}"></span>
        </div>

        <!-- 消息气泡 -->
        <div class="message-body-container">
            <!-- 消息正文 -->
            <div component="chat/message/body" class="message-body px-3 py-2 text-break" oncontextmenu="return false;">
                {messages.content}
            </div>

            <!-- 反应 (Reactions) -->
            <!-- IMPORT partials/chats/reactions.tpl -->

            <!-- 控制栏 -->
            <div component="chat/message/controls" class="message-controls">
                <div class="btn-group shadow-sm controls-group bg-body">
                    <!-- TTS 朗读 -->
                    <button class="btn btn-sm btn-link tts-btn" type="button" onclick="playTTS(this)" data-text="{messages.contentRaw}">
                        <i class="fa fa-volume-up"></i>
                    </button>

                    <!-- 改错 (模拟 HelloTalk) -->
                    <button class="btn btn-sm btn-link correction-btn" type="button" title="改错" onclick="triggerCorrection('{messages.fromUser.username}', '{messages.contentRaw}')">
                        <i class="fa fa-pencil-square-o text-success"></i>
                    </button>

                    <!-- 更多菜单 -->
                    <div class="btn-group d-inline-block">
                        <button class="btn btn-sm btn-link dropdown-toggle" data-bs-toggle="dropdown"><i class="fa fa-ellipsis-h"></i></button>
                        <ul class="dropdown-menu dropdown-menu-end p-1 text-sm list-unstyled custom-context-menu">
                            <li class="dropdown-item" onclick="triggerReply('{messages.fromUser.username}')"><i class="fa fa-reply me-2"></i> 回复</li>
                            <li class="dropdown-item" data-action="copy-text" data-mid="{messages.mid}"><i class="fa fa-copy me-2"></i> 复制</li>
                            
                            {{{ if (isAdminOrGlobalMod || (!config.disableChatMessageEditing && messages.self)) }}}
                            <li class="dropdown-divider"></li>
                            <li class="dropdown-item text-danger" data-action="delete"><i class="fa fa-trash me-2"></i> 撤回</li>
                            {{{ end }}}
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 嵌入式脚本：处理 TTS、国旗、改错 -->
    <script>
    (function() {
        // 1. 获取国旗逻辑 (通过 API 获取用户 Location)
        const uid = "{messages.fromuid}";
        const flagEl = document.querySelector('.chat-message[data-mid="{messages.messageId}"] .country-flag');
        
        // 简单的缓存避免重复请求
        if (!window.userLocationCache) window.userLocationCache = {};

        function setFlag(location) {
            if (!location) return;
            // 简单映射表：根据你的用户填写习惯修改
            const map = {
                'China': '🇨🇳', 'CN': '🇨🇳', '中国': '🇨🇳',
                'USA': '🇺🇸', 'US': '🇺🇸', '美国': '🇺🇸',
                'UK': '🇬🇧', 'Japan': '🇯🇵', 'Korea': '🇰🇷'
            };
            // 模糊匹配
            let flag = '';
            for (let key in map) {
                if (location.includes(key)) { flag = map[key]; break; }
            }
            // 如果匹配到了显示国旗，否则显示位置文字
            flagEl.innerHTML = flag ? flag : ''; 
            if(flag) flagEl.style.display = 'block';
        }

        if (window.userLocationCache[uid]) {
            setFlag(window.userLocationCache[uid]);
        } else {
            // 这里的 API 路径取决于 NodeBB 版本，通常是 /api/user/uid
            fetch(config.relative_path + '/api/user/' + uid)
                .then(res => res.json())
                .then(data => {
                    const loc = data.location || data.userData?.location || '';
                    window.userLocationCache[uid] = loc;
                    setFlag(loc);
                })
                .catch(e => console.log('Flag fetch error', e));
        }
    })();

    // 2. TTS 逻辑 (参考你提供的代码)
    window.ttsState = 'idle';
    window.currentAudio = null;

    window.playTTS = function(btn) {
        const text = btn.getAttribute('data-text');
        if (!text) return;

        // 如果正在播放，点击则停止
        if (window.ttsState === 'playing' && window.currentAudio) {
            window.currentAudio.pause();
            window.ttsState = 'idle';
            document.querySelectorAll('.tts-btn i').forEach(i => i.className = 'fa fa-volume-up');
            return;
        }

        // UI Loading
        const icon = btn.querySelector('i');
        icon.className = 'fa fa-spinner fa-spin';
        window.ttsState = 'loading';

        // 构建 URL
        const voice = 'zh-CN-XiaoxiaoMultilingualNeural'; // 指定发音人
        const rate = 0; // 语速
        const url = `https://t.leftsite.cn/tts?t=${encodeURIComponent(text)}&v=${voice}&r=${rate}`;

        if (window.currentAudio) window.currentAudio = null;
        window.currentAudio = new Audio(url);

        window.currentAudio.oncanplaythrough = function() {
            window.currentAudio.play();
            window.ttsState = 'playing';
            icon.className = 'fa fa-stop'; // 播放时显示停止图标
        };

        window.currentAudio.onended = function() {
            window.ttsState = 'idle';
            icon.className = 'fa fa-volume-up';
        };

        window.currentAudio.onerror = function() {
            window.ttsState = 'idle';
            icon.className = 'fa fa-exclamation-triangle';
            alert('TTS 接口请求失败');
        };
    };

    // 3. 改错功能触发器
    window.triggerCorrection = function(username, originalText) {
        // 模拟 HelloTalk 格式
        const composer = require('composer');
        const text = `> ${originalText}\n\n修改建议：\n~~错误~~ **正确**`;
        composer.newReply(ajaxify.data.tid, undefined, text);
    };
    
    // 4. 普通回复
    window.triggerReply = function(username) {
        const composer = require('composer');
        composer.newReply(ajaxify.data.tid, undefined, '@' + username + ' ');
    };
    </script>
</li>
