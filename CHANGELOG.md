# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

- add reason when return an order
- update README

## [1.0.8] - 19/07/2024

- increase product info in product detail page
- redirect to home when logout
- show loading dialog when action
- add RESET_POINT to loyalty history
- fix voucher render, wallet history COMPLETED_ORDER_COD_SYSTEM
- rename product_item --> product_card_item

## [1.0.7] - 15/07/2024

- filter search products
- add badge in product item & sheet add/buy now
- load more in shop page

## [1.0.6] 10/07/2024

- update UI
- prevent use Expired voucher
- add permission.AD_ID

## [1.0.4] 08/07/2024

- return order

## [1.0.3]

- chat
- check server connection
- UX: redirect
- search
- other stuff...

## Added

- Use loyalty point
- Place order from multi shop

## [v0.0.8-pre] - 25/04/2024

### Added

- Comment (on owner review)
- Use loyalty point to discount
- View Shop Detail
- Update: ShopInfo UI

## [v0.0.7-pre] - 20/04/2024

### Added

- Stateful Shell Route
- Dio (small part use)
- Notification
- Update UI

### Changed

- Use vtv_common package to keep all common file (entity, theme,...)

## [v0.0.5-pre] - 31/03/2024

- Notification
- Place order (cart, buy now)
- Order status
- Recent viewed products

## [v0.0.4-pre] - 29/03/2024

### Added

- **Authentication**
  - Login, Logout, Register & Auto get new accessToken if expired
  - Change Password, Forgot password
- **Product**
  - Show Category
  - Search Product, Show Product(Lazy, Pagination)
- Flash screen and icon launcher

### Changed

- App package name to 'hcmute.kltn.vtv'
- GetIt package instead using Injectable

### Fixed

- Utf-8 decode
- Expired Token check (because the document seem wrong!!)

## [v0.0.3-pre] - 26/01/2024

### Added

- login page
- forgot password page
- change password page
- update README

## [v0.0.2-pre] - 25/01/2024

### Added

- Flash Screen
- locator_service
- shared_preferences_service

## [v0.0.1-pre] - 20/01/2024

### Added

- Initial App

[unreleased]: https://github.com/venhha/flutter_vtv/compare/1.0.8...HEAD
[1.0.8]: https://github.com/venhha/flutter_vtv/compare/1.0.7...1.0.8
[1.0.7]: https://github.com/venhha/flutter_vtv/compare/1.0.6...1.0.7
[1.0.6]: https://github.com/venhha/flutter_vtv/compare/1.0.3...1.0.6
[1.0.3]: https://github.com/venhha/flutter_vtv/compare/v0.0.8-pre...1.0.3
[v0.0.8-pre]: https://github.com/venhha/flutter_vtv/compare/v0.0.7-pre...v0.0.8-pre
[v0.0.7-pre]: https://github.com/venhha/flutter_vtv/compare/v0.0.5-pre...v0.0.7-pre
[v0.0.5-pre]: https://github.com/venhha/flutter_vtv/compare/v0.0.4-pre...v0.0.5-pre
[v0.0.4-pre]: https://github.com/venhha/flutter_vtv/compare/v0.0.3-pre...v0.0.4-pre
[v0.0.3-pre]: https://github.com/venhha/flutter_vtv/compare/v0.0.2-pre...v0.0.3-pre
[v0.0.2-pre]: https://github.com/venhha/flutter_vtv/compare/v0.0.1-pre...v0.0.2-pre
[v0.0.1-pre]: https://github.com/venhha/flutter_vtv/releases/tag/v0.0.1-pre
