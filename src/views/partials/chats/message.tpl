<li component="chat/message" class="chat-message mx-2 pe-2 {{{ if messages.deleted }}} deleted{{{ end }}} {{{ if messages.pinned}}} pinned{{{ end }}} {{{ if messages.newSet }}}border-top pt-3{{{ end }}} {{{ if messages.self }}}self{{{ end }}} modern-chat-item" data-mid="{messages.messageId}" data-uid="{messages.fromuid}" data-index="{messages.index}" data-self="{messages.self}" data-break="{messages.newSet}" data-timestamp="{messages.timestamp}" data-username="{messages.fromUser.username}" data-displayname="{messages.fromUser.displayname}">

	{{{ if messages.parent }}}
	<!-- IMPORT partials/chats/parent.tpl -->
	{{{ end }}}

	<!-- 1. 头像区域：包含头像、在线状态、国旗 -->
	<div class="modern-avatar-wrapper {{{ if !messages.newSet }}}hidden{{{ end }}}">
		<a href="{config.relative_path}/user/{messages.fromUser.userslug}" class="text-decoration-none modern-avatar-link">
			{buildAvatar(messages.fromUser, "48px", true, "not-responsive modern-avatar")}
			
			<!-- 在线状态：移到右上角 -->
			<span class="modern-status-indicator {{{ if messages.fromUser.status }}}status-{messages.fromUser.status}{{{ end }}}"></span>
			
			<!-- 国旗：移到右下角 (假设后端传回了 nationality 字段) -->
			<!-- 如果没有 nationality 字段，此 span 会隐藏 -->
			{{{ if messages.fromUser.nationality }}}
			<span class="modern-flag-indicator" style="background-image: url('https://cdnjs.cloudflare.com/ajax/libs/flag-icon-css/3.4.6/flags/4x3/{messages.fromUser.nationality}.svg');"></span>
			{{{ end }}}
		</a>
	</div>

	<!-- 2. 消息内容区域：包含头部信息和气泡 -->
	<div class="modern-message-content">
		
		<!-- 头部：用户名和时间 (自己发送时隐藏) -->
		<div class="message-header lh-1 d-flex align-items-center gap-2 text-sm {{{ if !messages.newSet }}}hidden{{{ end }}} pb-2 modern-message-header">
			<span class="chat-user fw-semibold"><a href="{config.relative_path}/user/{messages.fromUser.userslug}">{messages.fromUser.displayname}</a></span>
			{{{ if messages.fromUser.banned }}}
			<span class="badge bg-danger">[[user:banned]]</span>
			{{{ end }}}
			{{{ if messages.fromUser.deleted }}}
			<span class="badge bg-danger">[[user:deleted]]</span>
			{{{ end }}}
			<span class="chat-timestamp text-muted timeago" title="{messages.timestampISO}"></span>

			<div component="chat/message/edited" class="text-muted ms-auto {{{ if !messages.edited }}}hidden{{{ end }}}" title="[[global:edited-timestamp, {isoTimeToLocaleString(messages.editedISO, config.userLang)}]]"><i class="fa fa-edit"></i></span></div>
		</div>

		<div class="message-body-wrapper modern-bubble-wrapper">
			<!-- 消息气泡 -->
			<div component="chat/message/body" class="message-body ps-0 py-0 overflow-auto text-break modern-bubble" id="content-{messages.messageId}">
				{messages.content}
			</div>

			<!-- 操作按钮组 -->
			<div component="chat/message/controls" class="position-relative modern-controls-wrapper">
				<div class="btn-group border shadow-sm controls position-absolute bg-body end-0 modern-controls" style="bottom:1rem;">
					
					<!-- 新增：TTS 朗读按钮 -->
					<button class="btn btn-sm btn-link modern-tts-btn" onclick="playTTS('{messages.messageId}')" title="朗读">
						<i class="fa fa-volume-up"></i>
					</button>

					<button class="btn btn-sm btn-link" data-action="reply" title="[[topic:reply]]"><i class="fa fa-reply"></i></button>

					<div class="btn-group d-inline-block">
						<button class="btn btn-sm btn-link dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fa fa-ellipsis" type="button"></i></button>
						<ul class="dropdown-menu dropdown-menu-end p-1 text-sm list-unstyled modern-dropdown-menu" role="menu">
							{{{ if (isAdminOrGlobalMod || (!config.disableChatMessageEditing && messages.self)) }}}
							<li>
								<a href="#" class="dropdown-item rounded-1" data-action="edit" role="menuitem"><span class="d-inline-flex align-items-center gap-2"><i class="fa fa-fw fa-pencil text-muted"></i> [[topic:edit]]</span></a>
							</li>
							
							<!-- 撤回/删除逻辑：JS会根据时间控制显示文本 -->
							<li>
								<a href="#" class="dropdown-item rounded-1 modern-withdraw-btn" data-action="delete" data-timestamp="{messages.timestamp}" role="menuitem">
									<span class="d-inline-flex align-items-center gap-2">
										<i class="fa fa-fw fa-trash text-muted"></i> 
										<span class="withdraw-text">删除</span>
									</span>
								</a>
							</li>
							
							<li>
								<a href="#" class="dropdown-item rounded-1" data-action="restore" role="menuitem"><span class="d-inline-flex align-items-center gap-2"><i class="fa fa-fw fa-repeat text-muted"></i> [[topic:restore]]</span></a>
							</li>

							<!-- 新增：改错按钮 -->
							<li>
								<a href="#" class="dropdown-item rounded-1" onclick="enableCorrectionMode('{messages.messageId}')" role="menuitem"><span class="d-inline-flex align-items-center gap-2"><i class="fa fa-fw fa-check-circle text-muted"></i> 改错</span></a>
							</li>
							{{{ end }}}

							{{{ if (isAdminOrGlobalMod || isOwner )}}}
							<li>
								<a href="#" class="dropdown-item rounded-1" data-action="pin" role="menuitem"><span class="d-inline-flex align-items-center gap-2"><i class="fa fa-fw fa-thumbtack text-muted"></i> [[modules:chat.pin-message]]</span></a>
							</li>
							<li>
								<a href="#" class="dropdown-item rounded-1" data-action="unpin" role="menuitem"><span class="d-inline-flex align-items-center gap-2"><i class="fa fa-fw fa-thumbtack fa-rotate-90 text-muted"></i> [[modules:chat.unpin-message]]</span></a>
							</li>
							<li class="dropdown-divider"></li>
							{{{ end }}}

							{{{ if isAdminOrGlobalMod }}}
							<li>
								<a href="#" class="dropdown-item rounded-1 chat-ip-button" role="menuitem">
									<span class="d-inline-flex align-items-center gap-2 show"><i class="fa fa-fw fa-info-circle text-muted"></i> [[modules:chat.show-ip]]</span>
									<span class="d-inline-flex align-items-center gap-2 copy hidden"><i class="fa fa-fw fa-copy text-muted"></i> <span class="copy-ip-text"></span></span>
								</a>
							</li>
							{{{ end }}}

							<li>
								<a href="#" class="dropdown-item rounded-1" data-action="copy-text" data-mid="{messages.mid}" role="menuitem"><span class="d-inline-flex align-items-center gap-2"><i class="fa fa-fw fa-copy text-muted"></i> [[modules:chat.copy-text]]</span></a>
							</li>

							<li>
								<a href="#" class="dropdown-item rounded-1" data-action="copy-link" data-mid="{messages.mid}" role="menuitem"><span class="d-inline-flex align-items-center gap-2"><i class="fa fa-fw fa-link text-muted"></i> [[modules:chat.copy-link]]</span></a>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
</li>

<!-- 内联脚本：处理 TTS 和 撤回逻辑 -->
<script>
	// 1. TTS 朗读功能
	function playTTS(messageId) {
		const contentDiv = document.getElementById('content-' + messageId);
		if (!contentDiv) return;
		const text = contentDiv.innerText;
		const audioUrl = 'https://t.leftsite.cn/api/audio?text=' + encodeURIComponent(text) + '&speaker=zh-CN-XiaoxiaoMultilingualNeural';
		const audio = new Audio(audioUrl);
		audio.play();
	}

	// 2. 改错功能 (简单模拟，实际需要配合编辑器插件)
	function enableCorrectionMode(messageId) {
		const contentDiv = document.getElementById('content-' + messageId);
		if (!contentDiv) return;
		// 这里仅做演示：将内容变为可编辑，并提示用户
		contentDiv.contentEditable = true;
		contentDiv.focus();
		contentDiv.style.border = "1px dashed red";
		alert("已进入改错模式，请直接修改文字。");
		// 实际开发中，这里需要绑定保存事件，提交到后端，并对比差异用红色标记
	}

	// 3. 撤回 vs 删除 逻辑 (页面加载后执行)
	document.addEventListener("DOMContentLoaded", function() {
		const withdrawBtns = document.querySelectorAll('.modern-withdraw-btn');
		const now = Date.now();
		withdrawBtns.forEach(btn => {
			const timestamp = parseInt(btn.getAttribute('data-timestamp'), 10);
			// 假设撤回时限为 2 分钟 (120000 毫秒)
			if (now - timestamp < 120000) {
				btn.querySelector('.withdraw-text').innerText = "撤回";
				// 注意：这里需要后端支持 'withdraw' action，否则仍执行 delete
			} else {
				btn.querySelector('.withdraw-text').innerText = "删除";
			}
		});
	});
</script>
