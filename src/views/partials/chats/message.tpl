<li component="chat/message" class="chat-message d-flex mb-2 {{{ if messages.deleted }}}deleted{{{ end }}} {{{ if messages.pinned }}}pinned{{{ end }}}" 
    data-mid="{messages.messageId}" 
    data-self="{messages.self}" 
    data-break="{messages.newSet}">

    <div class="message-container d-flex w-100 {{{ if messages.self }}}flex-row-reverse{{{ end }}}">
        
        <div class="avatar-wrapper">
            {{{ if messages.newSet }}}
            <a href="{config.relative_path}/user/{messages.fromUser.userslug}" class="text-decoration-none">
                {buildAvatar(messages.fromUser, "45px", true, "not-responsive chat-avatar")}
            </a>
            {{{ else }}}
            <div style="width: 45px;"></div> {{{ end }}}
        </div>

        <div class="message-content-wrapper d-flex flex-column {{{ if messages.self }}}align-items-end me-2{{{ else }}}align-items-start ms-2{{{ end }}}">
            
            <div class="message-body-container position-relative">
                <div component="chat/message/body" class="message-bubble shadow-sm">
                    {messages.content}
                </div>

                <small class="chat-timestamp text-muted" title="{messages.timestampISO}"></small>
            </div>

            </div>
    </div>
</li>
