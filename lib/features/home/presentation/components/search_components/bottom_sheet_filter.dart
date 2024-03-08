import 'package:flutter/material.dart';

import '../../../../../core/helpers/helpers.dart';
import '../../pages/search_products_page.dart';
import 'btn_search_types.dart';

class BottomSheetFilter extends StatefulWidget {
  /// default range is 0 - 10tr
  const BottomSheetFilter({
    super.key,
    required this.context,
    required this.minPrice,
    required this.maxPrice,
    required this.sortType,
    this.minRange = 0,
    this.maxRange = 10000000, // 10tr
    this.divisions = 100,
  });
  // required
  final BuildContext context;
  final int minPrice;
  final int maxPrice;
  final String sortType;

  // optional
  final double minRange;
  final double maxRange;
  final int divisions;

  @override
  State<BottomSheetFilter> createState() => _BottomSheetFilterState();
}

class _BottomSheetFilterState extends State<BottomSheetFilter> {
  late RangeValues _currentRangeValues;
  late double _minRange;
  late double _maxRange;
  late String _sortType;

  @override
  void initState() {
    super.initState();
    if (widget.minPrice < widget.minRange) {
      _minRange = widget.minPrice.toDouble();
    } else {
      _minRange = widget.minRange;
    }

    if (widget.maxPrice > widget.maxRange) {
      _maxRange = widget.maxPrice.toDouble();
    } else {
      _maxRange = widget.maxRange;
    }

    _currentRangeValues = RangeValues(
      widget.minPrice.toDouble(),
      widget.maxPrice.toDouble(),
    );

    _sortType = widget.sortType;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          _filterByPrice(),
          BtnSortTypes(
            initValue: _sortType,
            onSortChanged: (sortType) {
              // don't need setState because BtnSortTypes is a stateful widget itself
              _sortType = sortType;
            },
          ),
          _btnApplyCancel(context),
        ],
      ),
    );
  }

  Expanded _btnApplyCancel(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(
                  context,
                  FilterParams(
                    isFiltering: false,
                    minPrice: _currentRangeValues.start.round(),
                    maxPrice: _currentRangeValues.end.round(),
                    sortType: _sortType,
                  ),
                );
              },
              child: Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: const Center(child: Text('Hủy lọc')),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(
                    context,
                    // (min: _currentRangeValues.start.round(), max: _currentRangeValues.end.round()),
                    FilterParams(
                      isFiltering: true,
                      minPrice: _currentRangeValues.start.round(),
                      maxPrice: _currentRangeValues.end.round(),
                      sortType: _sortType,
                    ));
              },
              child: Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue[300],
                ),
                child: const Center(child: Text('Áp dụng')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _filterByPrice() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Lọc theo giá',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Từ: ${formatCurrency(_currentRangeValues.start.round())}'),
            Text('Đến: ${formatCurrency(_currentRangeValues.end.round())}'),
          ],
        ),
        const SizedBox(height: 10),
        RangeSlider(
          values: _currentRangeValues,
          min: _minRange,
          max: _maxRange,
          divisions: widget.divisions,
          labels: RangeLabels(
            formatCurrency(_currentRangeValues.start.round()),
            formatCurrency(_currentRangeValues.end.round()),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
        ),
      ],
    );
  }
}
