<li component="chat/message" class="chat-message mx-2 pe-2 {{{ if messages.deleted }}} deleted{{{ end }}} {{{ if messages.pinned}}} pinned{{{ end }}} {{{ if messages.newSet }}}border-top pt-3{{{ end }}} {{{ if messages.self }}}self{{{ end }}} modern-chat-item" data-mid="{messages.messageId}" data-uid="{messages.fromuid}" data-index="{messages.index}" data-self="{messages.self}" data-break="{messages.newSet}" data-timestamp="{messages.timestamp}" data-username="{messages.fromUser.username}" data-displayname="{messages.fromUser.displayname}">

	{{{ if messages.parent }}}
	<!-- IMPORT partials/chats/parent.tpl -->
	{{{ end }}}

	<!-- 头像区域 -->
	<div class="modern-avatar-wrapper {{{ if !messages.newSet }}}hidden{{{ end }}}">
		<a href="{config.relative_path}/user/{messages.fromUser.userslug}" class="text-decoration-none modern-avatar-link">
			{buildAvatar(messages.fromUser, "48px", true, "not-responsive modern-avatar")}
			<!-- 在线状态 -->
			<span class="modern-status-indicator {{{ if messages.fromUser.status }}}status-{messages.fromUser.status}{{{ end }}}"></span>
			<!-- 国旗 (注意这里改成 nationality) -->
			<span class="modern-flag-indicator" data-country="{messages.fromUser.nationality}"></span>
		</a>
	</div>

	<!-- 消息内容区域 -->
	<div class="modern-message-content">
		<div class="message-header lh-1 d-flex align-items-center gap-2 text-sm {{{ if !messages.newSet }}}hidden{{{ end }}} pb-2 modern-message-header">
			<span class="chat-user fw-semibold"><a href="{config.relative_path}/user/{messages.fromUser.userslug}">{messages.fromUser.displayname}</a></span>
			<span class="chat-timestamp text-muted timeago" title="{messages.timestampISO}"></span>
		</div>
		<div class="message-body-wrapper modern-bubble-wrapper">
			<div component="chat/message/body" class="message-body ps-0 py-0 overflow-auto text-break modern-bubble">
				{messages.content}
			</div>
			
			<!-- 消息操作按钮 -->
			<div component="chat/message/controls" class="position-relative modern-controls-wrapper">
				<div class="btn-group border shadow-sm controls position-absolute bg-body end-0 modern-controls" style="bottom:1rem;">
					<button class="btn btn-sm btn-link modern-tts-btn" data-action="tts-read" title="朗读"><i class="fa fa-volume-up"></i></button>
					<button class="btn btn-sm btn-link" data-action="reply" title="回复"><i class="fa fa-reply"></i></button>
					<div class="btn-group d-inline-block">
						<button class="btn btn-sm btn-link dropdown-toggle" data-bs-toggle="dropdown"><i class="fa fa-ellipsis"></i></button>
						<ul class="dropdown-menu dropdown-menu-end p-1 text-sm list-unstyled modern-dropdown-menu">
							{{{ if (isAdminOrGlobalMod || (!config.disableChatMessageEditing && messages.self)) }}}
							<li><a href="#" class="dropdown-item" data-action="edit"><i class="fa fa-pencil text-muted"></i> 编辑</a></li>
							<li><a href="#" class="dropdown-item" data-action="delete"><i class="fa fa-trash text-muted"></i> 撤回/删除</a></li>
							{{{ end }}}
							<li><a href="#" class="dropdown-item" data-action="copy-text"><i class="fa fa-copy text-muted"></i> 复制</a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
</li>
