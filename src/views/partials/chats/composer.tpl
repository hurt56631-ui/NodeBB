<div component="chat/composer" class="chat-app-composer d-flex flex-column">
	<!-- 正在回复提示（保持 NodeBB 原生逻辑） -->
	<div component="chat/composer/replying-to" data-tomid="" class="reply-indicator text-sm px-3 py-1 d-flex gap-2 align-items-center hidden">
		<i class="fa fa-reply text-muted"></i>
		<div component="chat/composer/replying-to-text" class="text-truncate"></div>
		<button component="chat/composer/replying-to-cancel" class="btn btn-sm ms-auto"><i class="fa fa-times"></i></button>
	</div>

	<!-- 主输入区域 -->
	<div class="composer-main-bar d-flex align-items-end gap-2 px-2 py-2">
		
		<!-- 1. 表情按钮 (左侧) -->
		<div class="composer-left-actions">
			<button class="btn-action" type="button" component="chat/emoji/picker" title="表情">
				<i class="fa fa-smile-o"></i>
			</button>
		</div>

		<!-- 2. 大输入框 (中间) -->
		<div class="composer-input-wrapper flex-grow-1">
			<textarea component="chat/input" 
				placeholder="请输入内容..." 
				class="chat-input-app mousetrap" 
				style="height: 40px; max-height: 120px;"></textarea>
		</div>

		<!-- 3. 动态动作按钮 (右侧) -->
		<div class="composer-right-actions">
			<!-- 默认是语音/更多按钮，输入文字后通过 JS 切换类名 -->
			<button id="chat-dynamic-btn" class="btn-main-action mode-voice" type="button" data-action="send">
				<i class="fa fa-microphone icon-mic"></i>
				<i class="fa fa-plus icon-plus"></i>
				<span class="text-send">发送</span>
			</button>
		</div>
	</div>

	<!-- 隐藏的上传表单 -->
	<form class="hidden" component="chat/upload" method="post" enctype="multipart/form-data">
		<input type="file" name="files[]" multiple class="hidden"/>
	</form>
</div>
