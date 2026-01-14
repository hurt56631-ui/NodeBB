<li component="chat/message" class="chat-message mx-2 pe-2 {{{ if messages.deleted }}} deleted{{{ end }}} {{{ if messages.pinned}}} pinned{{{ end }}} {{{ if messages.newSet }}}new-set pt-3{{{ end }}}" data-mid="{messages.messageId}" data-uid="{messages.fromuid}" data-index="{messages.index}" data-self="{messages.self}" data-break="{messages.newSet}" data-timestamp="{messages.timestamp}" data-username="{messages.fromUser.username}" data-displayname="{messages.fromUser.displayname}">

	{{{ if messages.parent }}}
	<!-- IMPORT partials/chats/parent.tpl -->
	{{{ end }}}

    <!-- 1. 头像区域 (Avatar Container) -->
    <div class="chat-avatar-wrapper">
        <a href="{config.relative_path}/user/{messages.fromUser.userslug}" class="text-decoration-none avatar-link">
            <!-- 尺寸改为 48px -->
            {buildAvatar(messages.fromUser, "48px", true, "not-responsive")}
            
            <!-- 在线状态 (右上角) -->
            <span class="status-dot {{{ if messages.fromUser.status }}}status-{messages.fromUser.status}{{{ end }}}"></span>
            
            <!-- 国旗占位符 (右下角) - 需配合 JS 或插件填充具体国旗 -->
            <span class="flag-icon"></span>
        </a>
    </div>

    <!-- 2. 内容区域 (Content Wrapper) -->
    <div class="message-content-wrapper">
        
        <!-- 用户名与时间 (仅他人消息显示，自己消息通过 CSS 隐藏) -->
        <div class="message-header lh-1 d-flex align-items-center gap-2 text-sm {{{ if !messages.newSet }}}hidden-name{{{ end }}} pb-1">
            <span class="chat-user fw-semibold">
                <a href="{config.relative_path}/user/{messages.fromUser.userslug}">{messages.fromUser.displayname}</a>
            </span>
            {{{ if messages.fromUser.banned }}}
            <span class="badge bg-danger">[[user:banned]]</span>
            {{{ end }}}
            {{{ if messages.fromUser.deleted }}}
            <span class="badge bg-danger">[[user:deleted]]</span>
            {{{ end }}}
            <span class="chat-timestamp text-muted timeago" title="{messages.timestampISO}"></span>
            
            <div component="chat/message/edited" class="text-muted ms-auto {{{ if !messages.edited }}}hidden{{{ end }}}" title="[[global:edited-timestamp, {isoTimeToLocaleString(messages.editedISO, config.userLang)}]]"><i class="fa fa-edit"></i></div>
        </div>

        <!-- 消息气泡与控制栏 -->
        <div class="message-body-container position-relative">
            <div component="chat/message/body" class="message-body px-3 py-2 overflow-auto text-break">
                <!-- 纠错标记示例 (需JS配合): <span class="typo-mark">错字</span> -->
                {messages.content}
            </div>

            <!-- IMPORT partials/chats/reactions.tpl -->

            <!-- 控制按钮组 (Controls) -->
            <div component="chat/message/controls" class="message-controls">
                <div class="btn-group shadow-sm controls-group bg-body">
                    <!-- TTS 朗读按钮 (新增) -->
                    <button class="btn btn-sm btn-link tts-btn" title="朗读" data-text="{messages.contentRaw}" onclick="/* JS Needed for TTS: https://t.leftsite.cn */">
                        <i class="fa fa-volume-up"></i>
                    </button>

                    <!-- IMPORT partials/chats/add-reaction.tpl -->
                    <button class="btn btn-sm btn-link" data-action="reply" title="[[topic:reply]]"><i class="fa fa-reply"></i></button>

                    <div class="btn-group d-inline-block">
                        <button class="btn btn-sm btn-link dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fa fa-ellipsis" type="button"></i></button>
                        <ul class="dropdown-menu dropdown-menu-end p-1 text-sm list-unstyled custom-context-menu" role="menu">
                            <!-- 撤回/删除逻辑 -->
                            {{{ if (isAdminOrGlobalMod || (!config.disableChatMessageEditing && messages.self)) }}}
                            <li>
                                <a href="#" class="dropdown-item rounded-1" data-action="edit" role="menuitem"><span class="d-inline-flex align-items-center gap-2"><i class="fa fa-fw fa-pencil text-muted"></i> [[topic:edit]]</span></a>
                            </li>
                            <li>
                                <!-- 此处根据时间判断显示撤回还是删除通常需要JS，这里保留删除按钮，CSS可改样式 -->
                                <a href="#" class="dropdown-item rounded-1" data-action="delete" role="menuitem"><span class="d-inline-flex align-items-center gap-2"><i class="fa fa-fw fa-trash text-muted"></i> [[topic:delete]]</span></a>
                            </li>
                            <li>
                                <a href="#" class="dropdown-item rounded-1" data-action="restore" role="menuitem"><span class="d-inline-flex align-items-center gap-2"><i class="fa fa-fw fa-repeat text-muted"></i> [[topic:restore]]</span></a>
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
