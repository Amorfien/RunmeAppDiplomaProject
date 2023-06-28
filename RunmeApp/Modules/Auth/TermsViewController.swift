//
//  TermsViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 28.06.2023.
//

import UIKit

final class TermsViewController: UIViewController {

    private let termsTextView: UITextView = {
        let text = UITextView()
        text.text = """
1. Общие положения Пользовательского соглашения

1.1. В настоящем документе и вытекающих или связанным с ним отношениях Сторон применяются следующие термины и определения:

а) Платформа — программно-аппаратные средства, интегрированные с Сайтом Администрации;

б) Пользователь — дееспособное физическое лицо, присоединившееся к настоящему Соглашению в собственном интересе либо выступающее от имени и в интересах представляемого им юридического лица.

в) Сайт Администрации/ Сайт — интернет-сайты, размещенные в домене ________.ru и его поддоменах.

г) Сервис — комплекс услуг и лицензия, предоставляемые Пользователю с использованием Платформы.

д) Соглашение - настоящее соглашение со всеми дополнениями и изменениями.
Готовое решение для вашего бизнеса

Пакет документов для сайта
Документы для популярных моделей интернет-сервисов. Гарантия ограничения ответственности и налоговой чистоты.
Ознакомиться с решением
1.2. Использование вами Сервиса любым способом и в любой форме в пределах его объявленных функциональных возможностей, включая:

просмотр размещенных на Сайте материалов;
регистрация и/или авторизация на Сайте,
размещение или отображение на Сайте любых материалов, включая но не ограничиваясь такими как: тексты, гипертекстовые ссылки, изображения, аудио и видео- файлы, сведения и/или иная информация,
создает договор на условиях настоящего Соглашения в соответствии с положениями ст.437 и 438 Гражданского кодекса Российской Федерации.

1.3. Воспользовавшись любой из указанных выше возможностей по использованию Сервиса вы подтверждаете, что:

а) Ознакомились с условиями настоящего Соглашения в полном объеме до начала использования Сервиса.

б) Принимаете все условия настоящего Соглашения в полном объеме без каких-либо изъятий и ограничений с вашей стороны и обязуетесь их соблюдать или прекратить использование Сервиса. Если вы не согласны с условиями настоящего Соглашения или не имеете права на заключение договора на их основе, вам следует незамедлительно прекратить любое использование Сервиса.

в) Соглашение (в том числе любая из его частей) может быть изменено Администрацией без какого-либо специального уведомления. Новая редакция Соглашения вступает в силу с момента ее размещения на Сайте Администрации либо доведения до сведения Пользователя в иной удобной форме, если иное не предусмотрено новой редакцией Соглашения.

Важно знать! Для придания юридической силы дисклаймеру, включенному в текст соглашения с пользователем, необходимо подтвердить факт ознакомления и принятия пользователем его условий. Для этого используется предусмотренный законодательством механизм заключения договоров.
2. Условия пользования по Соглашению

2.1. Использование функциональных возможностей Сервиса допускается только после прохождения Пользователем регистрации и авторизации на Сайте в соответствии с установленной Администрацией процедурой.

2.2. Технические, организационные и коммерческие условия использования Сервиса, в том числе его функциональных возможностей доводятся до сведения Пользователей путем отдельного размещения на Сайте или путем нотификации Пользователей.

Готовое решение для вашего бизнеса

Пользовательское соглашение
Определяет условия бесплатного использования сайта
Ознакомиться с решением
2.3. Выбранные Пользователем логин и пароль являются необходимой и достаточной информацией для доступа Пользователя на Сайт. Пользователь не имеет права передавать свои логин и пароль третьим лицам, несет полную ответственность за их сохранность, самостоятельно выбирая способ их хранения.

3. Лицензия на использование Сайта и допустимое использование Сервиса

В данном разеле описываются разрешенные способы использования Сайта и предоставляемого на его основе Сервиса. Безвозмездность лицензии препятствует применению Закона О защите прав потребителя в случае, когда на стороне пользователя – физическое лицо.

4. Гарантии Пользователя по Соглашению

В разеле указываются гарантии и заверения со стороны пользователя о соблюдении требований законодательства и Пользовательского соглашения при использовании Сайта и Сервиса на его основе. Данные положения необходимы, в частности, для последующего возложения ответственности на пользователя за нарушения законодателства или прав третьих лиц в связи с публикацией на сайте противоправных материалов.

5. Лицензия на использование пользовательского контента

При организации социального сервиса или платформы для размещения пользователями различных материалов в публичном доступе необходимо оформлять лицензионное соглашение с каждым пользователем на использование его материалов в рамках такого Интернет-сервиса. Например разрешение пользователя на использование его фотографиии может понадобиться для ее публикации на страницах других пользователей и т.д.

Кроме того, получение лицензии подтверждает факт использования контента с разрешения пользователя, который отвечает за наличие у него полномочий на выдачу такой лицензии
6. Ограничения использования

В Пользовательском соглашении необходимо с достаточной ясностью изложить условия об ограничении ответственности за предоставление и использование Сервиса, в том числе публикуемый с его использованием пользовательский контент.
Помимо этого, соблюдение требований федерального закона Об информации в редакции нового антипиратского закона предполагает удаление информационным посредником спорных материалов по первому обращению правообладателя. Поэтому Пользовательское соглашение должно предоставлять владельцу интернет-сервиса такую возможность без предварительного согласования и уведомления пользователя
7. Уведомления и рассылка

Данное положение Соглашения направлено на соблюдение требований о недопущении СПАМа.
8. Условия использования аналога собственноручной подписи

Раздел включает порядок использования логина и пароля или адреса электронной почты в качестве ключа простой электронной подписи. Данное условие необходимо для придания юридической силы всем действиям сторон и упрощения возможного документооборота.
"""
        return text
    }()

    override func loadView() {
        self.view = termsTextView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Пользовательское соглашение"
    }


}
