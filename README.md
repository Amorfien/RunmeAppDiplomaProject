# RunmeAppDiplomaProject

### Дипломная работа по курсу "iOS-разработчик с нуля" от Нетологии

## Приложение для бегунов RunmeApp

* Используемая архитектура: MVVM-C - пассивная архитектура (без Combine/Rx) с координатором.
* Интерфейс приложения: UIKit
* Серверная часть: сервисы Firebase + новостной REST API
* Данные на устройстве: CoreData для хранения и фильтрации результатов
* Dependencies: Firebase (firestore, storage, authentication)


  Регистрация и авторизация в приложении осуществляется с помощью мобильного телефона и смс с кодом. Между сессиями возможна авторизация по биометрическим датчикам.

  ![image](https://github.com/Amorfien/RunmeAppDiplomaProject/assets/77209692/58c3149b-3990-469c-a2f4-ef0ee5335012) ![image](https://github.com/Amorfien/RunmeAppDiplomaProject/assets/77209692/30484d7e-c579-43d7-9807-38d3fed3e092)

  Сервис СМС-сообщений от Firebase работает не идеально - не на все операторы доходят сообщения. Но есть возможность захардкодить любой номер телефона в базе как зарегистрированный.

![image](https://github.com/Amorfien/RunmeAppDiplomaProject/assets/77209692/5cc3e2d1-38af-42eb-95b5-bb7ae226c148) ![image](https://github.com/Amorfien/RunmeAppDiplomaProject/assets/77209692/44b36aaf-a990-4a42-acb2-315a8e405146)

Стартовый экран зарегистрированного пользователя - экран профиля с личной информацией, статусом, рекордами и ачивками. Дополнительно кнопка настроек и добавление информации о новой тренировке

![image](https://github.com/Amorfien/RunmeAppDiplomaProject/assets/77209692/84cda882-e07b-480b-bd2c-2e11fb6d0894) ![image](https://github.com/Amorfien/RunmeAppDiplomaProject/assets/77209692/2a026f5d-1c64-4c06-abed-7e033ae70549)

На первой вкладке навигации находятся посты-тренировки всех участников с возможностью поставить лайк, а также спортивные новости с околобеговой тематикой. Понравившуюся новость можно сохранить себе в избранное (третья вкладка)

![image](https://github.com/Amorfien/RunmeAppDiplomaProject/assets/77209692/eca63c89-974d-4f6d-9b33-f0d19d6cdff2) ![image](https://github.com/Amorfien/RunmeAppDiplomaProject/assets/77209692/51d176c5-635c-4be3-9a51-73b2b44293cf)

На последней вкладке находятся результаты бегунов на разные дистанции. Есть возможность отфильтровать участников по полу. Тут можно посмотреть профиль любого пользователя

![image](https://github.com/Amorfien/RunmeAppDiplomaProject/assets/77209692/b4d5da16-5ab3-4272-ae0d-a21e21ea6a29) ![image](https://github.com/Amorfien/RunmeAppDiplomaProject/assets/77209692/39fde227-9fd0-48d8-bee6-5ffb6f668511)







