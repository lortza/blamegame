function displayCookieNotice() {
  let cookieNotice = localStorage.getItem('cookie_notice')
  if (cookieNotice != 'true') {
    alert("Hi there! This site uses a cookie to remember your name. We delete it at the end of each game. Have fun, y'all!")
    localStorage.setItem('cookie_notice', 'true');
  }
}

function validateGameCode(currentGameCodes) {
  let gameCodeField = document.getElementById('player_game_code');
  let errorHelperText = document.getElementById('error_helper_text');
  let submitButton = document.getElementById('submit_button');

  gameCodeField.addEventListener('blur', function () {
    let gameCodeValue = gameCodeField.value.toUpperCase();
    let valid_game_code = currentGameCodes.includes(gameCodeValue);

    if (valid_game_code) {
      errorHelperText.classList.add('hidden')
      gameCodeField.classList.remove('input-error')
      submitButton.classList.remove('hidden')
    } else {
      errorHelperText.classList.remove('hidden')
      gameCodeField.classList.add('input-error')
      submitButton.classList.add('hidden')
    }
  }) // blur
}
