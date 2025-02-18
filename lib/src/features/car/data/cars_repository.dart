import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/src/features/car/domain/car.dart';
import 'package:drive_safe/src/features/car/domain/car_data.dart';
import 'package:drive_safe/src/shared/constants/strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cars_repository.g.dart';

class CarsRepository {
  CarsRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Future<Car?> fetchCar(String carId) async {
    final snapshot = await _carDocumentRef(carId).get();
    return snapshot.data();
  }

  Future<Car> createCar(CarData carData) async {
    final String carId = carData.id!;

    final car = Car(
      id: carId,
      type: carData.type!,
      description: carData.description!,
    );

    await _carDocumentRef(carId).set(car);
    return car;
  }

  DocumentReference<Car> _carDocumentRef(String carId) {
    return _firestore
        .collection(Strings.carsCollection)
        .doc(carId)
        .withConverter(
          fromFirestore: (doc, _) => Car.fromMap(doc.data()!),
          toFirestore: (Car car, _) => car.toMap(),
        );
  }

  Future<Car> updateCarType(String carId, String type) async {
    final carsRef = _firestore.collection(Strings.carsCollection).doc(carId);

    // Update the car document in Firestore
    await carsRef.update({
      'type': type,
    });

    // Fetch the updated car document
    final updatedSnapshot = await carsRef.get();
    if (!updatedSnapshot.exists) throw Exception('Car not found');

    return Car.fromMap(updatedSnapshot.data()!);
  }

  Future<Car> updateCarDescription(String carId, String description) async {
    final carsRef = _firestore.collection(Strings.carsCollection).doc(carId);

    // Update the car document in Firestore
    await carsRef.update({
      'description': description,
    });

    // Fetch the updated car document
    final updatedSnapshot = await carsRef.get();
    if (!updatedSnapshot.exists) throw Exception('Car not found');

    return Car.fromMap(updatedSnapshot.data()!);
  }
}

@Riverpod(keepAlive: true)
CarsRepository carsRepository(Ref ref) {
  return CarsRepository(FirebaseFirestore.instance);
}
