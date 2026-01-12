<div component="chat/composer" class="chat-app-input-bar">
    <div class="composer-container">
        <!-- 1. 输入框 (居中并自动伸缩) -->
        <div class="input-wrapper">
            <textarea component="chat/input" rows="1" placeholder="输入内容..." class="chat-app-textarea"></textarea>
        </div>

        <!-- 2. 右侧功能区 (图标集合) -->
        <div class="action-icons-group">
            <!-- 表情按钮 -->
            <button class="icon-btn" type="button" component="chat/emoji/picker">
                <i class="fa fa-smile-o"></i>
            </button>
            
            <!-- 加号按钮 (触发拍照/图片) -->
            {{{ if canUpload }}}
            <button class="icon-btn" type="button" onclick="$('#chat-real-upload').click()">
                <i class="fa fa-plus-circle"></i>
            </button>
            {{{ end }}}

            <!-- 动态按钮：发送或语音 -->
            <button id="chat-submit-btn" class="main-action-btn mode-voice" data-action="send">
                <i class="fa fa-microphone icon-mic"></i>
                <span class="text-send">发送</span>
            </button>
        </div>
    </div>

    <!-- 隐藏的真实上传控件 -->
    <form class="hidden" component="chat/upload" method="post" enctype="multipart/form-data">
        <input id="chat-real-upload" type="file" name="files[]" multiple accept="image/*" class="hidden"/>
    </form>
</div>
