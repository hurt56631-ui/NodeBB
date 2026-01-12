<div component="chat/composer" class="chat-app-bottom-bar">
    <div class="composer-main d-flex align-items-end gap-2 p-2">
        <!-- 1. 表情按钮 -->
        <button class="btn-chat-icon" type="button" component="chat/emoji/picker">
            <i class="fa fa-smile-o"></i>
        </button>

        <!-- 2. 图片/拍照按钮 (微信的 + 号位置) -->
        {{{ if canUpload }}}
        <button class="btn-chat-icon" type="button" onclick="$('#chat-upload-input').click()">
            <i class="fa fa-plus-circle"></i>
        </button>
        {{{ end }}}

        <!-- 3. 输入框 -->
        <div class="input-flex-wrapper">
            <textarea component="chat/input" class="chat-input-app" placeholder="输入内容..." rows="1"></textarea>
        </div>

        <!-- 4. 动态按钮 (语音/发送) -->
        <div class="action-btn-wrapper">
            <button id="chat-main-btn" class="btn-send-app mode-voice" data-action="send">
                <i class="fa fa-microphone icon-mic"></i>
                <span class="text-send d-none">发送</span>
            </button>
        </div>
    </div>

    <!-- 隐藏的上传表单 (不可删) -->
    <form class="hidden" component="chat/upload" method="post" enctype="multipart/form-data">
        <input id="chat-upload-input" type="file" name="files[]" multiple accept="image/*" class="hidden"/>
    </form>
</div>
