<li component="chat/message" class="chat-message mx-2 pe-2 {{{ if messages.deleted }}} deleted{{{ end }}} {{{ if messages.pinned}}} pinned{{{ end }}} {{{ if messages.newSet }}}border-top pt-3{{{ end }}} {{{ if messages.self }}}self{{{ end }}} modern-chat-item" data-mid="{messages.messageId}" data-uid="{messages.fromuid}" data-index="{messages.index}" data-self="{messages.self}" data-break="{messages.newSet}" data-timestamp="{messages.timestamp}" data-username="{messages.fromUser.username}" data-displayname="{messages.fromUser.displayname}">

    <div class="modern-avatar-wrapper {{{ if !messages.newSet }}}hidden{{{ end }}}">
        <a href="{config.relative_path}/user/{messages.fromUser.userslug}" class="text-decoration-none modern-avatar-link">
            {buildAvatar(messages.fromUser, "48px", true, "not-responsive modern-avatar")}
            <span class="modern-status-indicator {{{ if messages.fromUser.status }}}status-{messages.fromUser.status}{{{ end }}}"></span>
            {{{ if messages.fromUser.nationality }}}
            <div class="modern-flag-indicator" data-nat="{messages.fromUser.nationality}"></div>
            {{{ end }}}
        </a>
    </div>

    <div class="modern-message-content">
        <div class="message-header lh-1 d-flex align-items-center gap-2 text-sm {{{ if !messages.newSet }}}hidden{{{ end }}} pb-2 modern-message-header">
            <span class="chat-user fw-semibold"><a href="{config.relative_path}/user/{messages.fromUser.userslug}">{messages.fromUser.displayname}</a></span>
            {{{ if messages.fromUser.banned }}}<span class="badge bg-danger">[[user:banned]]</span>{{{ end }}}
            {{{ if messages.fromUser.deleted }}}<span class="badge bg-danger">[[user:deleted]]</span>{{{ end }}}
            <span class="chat-timestamp text-muted timeago" title="{messages.timestampISO}"></span>
            <div component="chat/message/edited" class="text-muted ms-auto {{{ if !messages.edited }}}hidden{{{ end }}}" title="[[global:edited-timestamp, {isoTimeToLocaleString(messages.editedISO, config.userLang)}]]"><i class="fa fa-edit"></i></div>
        </div>

        <div class="message-body-wrapper modern-bubble-wrapper">
            <div component="chat/message/body" class="message-body ps-0 py-0 overflow-auto text-break modern-bubble" id="content-{messages.messageId}">
                {messages.content}
            </div>

            <div component="chat/message/controls" class="position-relative modern-controls-wrapper">
                <div class="btn-group border shadow-sm controls position-absolute bg-body end-0 modern-controls" style="bottom:1rem;">
                    <button class="btn btn-sm btn-link modern-tts-btn" onclick="handleTTSClick('{messages.messageId}', this)">
                        <i class="fa fa-volume-up"></i>
                    </button>
                    <button class="btn btn-sm btn-link" data-action="reply"><i class="fa fa-reply"></i></button>
                    <div class="btn-group d-inline-block">
                        <button class="btn btn-sm btn-link dropdown-toggle" data-bs-toggle="dropdown"><i class="fa fa-ellipsis"></i></button>
                        <ul class="dropdown-menu dropdown-menu-end p-1 text-sm list-unstyled">
                            {{{ if (isAdminOrGlobalMod || (!config.disableChatMessageEditing && messages.self)) }}}
                            <li><a href="#" class="dropdown-item rounded-1" data-action="edit"><i class="fa fa-pencil text-muted"></i> [[topic:edit]]</a></li>
                            <li><a href="#" class="dropdown-item rounded-1 modern-withdraw-btn" data-action="delete" data-timestamp="{messages.timestamp}"><i class="fa fa-trash text-muted"></i> <span class="withdraw-text">删除</span></a></li>
                            <li><a href="#" class="dropdown-item rounded-1" onclick="enableCorrectionMode('{messages.messageId}')"><i class="fa fa-check-circle text-muted"></i> 改错</a></li>
                            {{{ end }}}
                            <li><a href="#" class="dropdown-item rounded-1" data-action="copy-text"><i class="fa fa-copy text-muted"></i> 复制文本</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</li>

<script>
    // 使用与 React 代码一致的配置
    const TTS_CONFIG = {
        baseUrl: 'https://t.leftsite.cn/api/tts', // 修正路径为 /api/tts
        voice: 'zh-CN-XiaoxiaoMultilingualNeural'
    };

    async function handleTTSClick(messageId, btn) {
        const icon = btn.querySelector('i');
        const text = document.getElementById('content-' + messageId).innerText.trim();
        
        if (!text) return;

        // 切换加载状态
        icon.className = 'fa fa-spinner fa-spin';
        btn.disabled = true;

        try {
            // 参考 React 代码使用 fetch 获取 blob
            const url = `${TTS_CONFIG.baseUrl}?t=${encodeURIComponent(text)}&v=${TTS_CONFIG.voice}`;
            const response = await fetch(url);
            
            if (!response.ok) throw new Error('Network response was not ok');
            
            const blob = await response.blob();
            const audioUrl = URL.createObjectURL(blob);
            const audio = new Audio(audioUrl);

            audio.onended = () => {
                icon.className = 'fa fa-volume-up';
                btn.disabled = false;
                URL.revokeObjectURL(audioUrl); // 释放内存
            };

            await audio.play();
        } catch (err) {
            console.error('TTS Error:', err);
            icon.className = 'fa fa-exclamation-triangle text-danger';
            setTimeout(() => {
                icon.className = 'fa fa-volume-up';
                btn.disabled = false;
            }, 2000);
        }
    }

    function enableCorrectionMode(mid) {
        const sel = window.getSelection().toString();
        if(!sel) return alert("请先选中文字");
        const contentEl = document.getElementById('content-' + mid);
        contentEl.innerHTML = contentEl.innerHTML.replace(sel, `<span style="color:red;text-decoration:underline;">${sel}</span>`);
    }
</script>
