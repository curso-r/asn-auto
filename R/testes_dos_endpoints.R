input_dict = list(
  'cylinders' = 8,
  'displacement' = 320,
  'horsepower' = 150,
  'weight' = 3449,
  'acceleration' = 11.0,
  'year' = 70,
  'origin' = 1
)

a <- httr::GET("https://auto-ux4ub5akeq-uc.a.run.app/")
httr::content(a)

a <- httr::GET("https://auto-ux4ub5akeq-uc.a.run.app/train")
httr::content(a)

a <- httr::GET("https://auto-ux4ub5akeq-uc.a.run.app/env", query = list(key = "STORAGE_ACCOUNT_KEY"))
httr::content(a)

a <- httr::POST("https://auto-ux4ub5akeq-uc.a.run.app/score", body = input_dict, encode="json")
httr::content(a)
