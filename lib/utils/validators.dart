class Validator {
  static String? password(value) {
    if (value == '') return 'Пароль не может быть пустым';
    if (value == 'пиписька') {
      return 'Пароль не может быть пиписька (по фану)';
    }
    if (value.length <= 8) return 'Пароль должен быть длиннее 8 символов';
    return null;
  }

  static String? email(value) {
    return null;
  }
}
