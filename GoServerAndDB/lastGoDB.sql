-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema godb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema godb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `godb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `godb` ;

-- -----------------------------------------------------
-- Table `godb`.`ingredients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `godb`.`ingredients` (
  `name` VARCHAR(200) NOT NULL,
  `calorie` INT NULL DEFAULT NULL,
  `type` VARCHAR(100) NULL DEFAULT '"NULL"',
  `quantity` INT NULL DEFAULT '1',
  PRIMARY KEY (`name`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `godb`.`list`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `godb`.`list` (
  `ingredient` VARCHAR(60) NULL DEFAULT NULL,
  `quantity` INT NULL DEFAULT '1')
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `godb`.`recepie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `godb`.`recepie` (
  `name` VARCHAR(120) NOT NULL,
  `time` TIME NULL DEFAULT NULL,
  `howto` VARCHAR(2500) NULL DEFAULT 'Cuire',
  PRIMARY KEY (`name`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `godb`.`recepie_has_ingredients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `godb`.`recepie_has_ingredients` (
  `recepie_name` VARCHAR(120) NOT NULL,
  `ingredients_name` VARCHAR(200) NOT NULL,
  `needed_quantity` INT NULL DEFAULT '1',
  PRIMARY KEY (`recepie_name`, `ingredients_name`),
  INDEX `fk_recepie_has_ingredients_ingredients1_idx` (`ingredients_name` ASC) VISIBLE,
  INDEX `fk_recepie_has_ingredients_recepie_idx` (`recepie_name` ASC) VISIBLE,
  CONSTRAINT `fk_recepie_has_ingredients_ingredients1`
    FOREIGN KEY (`ingredients_name`)
    REFERENCES `godb`.`ingredients` (`name`),
  CONSTRAINT `fk_recepie_has_ingredients_recepie`
    FOREIGN KEY (`recepie_name`)
    REFERENCES `godb`.`recepie` (`name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `godb`.`recipesofweek`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `godb`.`recipesofweek` (
  `day` VARCHAR(60) NOT NULL,
  `recepie_name` VARCHAR(120) NOT NULL,
  PRIMARY KEY (`day`, `recepie_name`),
  UNIQUE INDEX `day_UNIQUE` (`day` ASC) VISIBLE,
  INDEX `fk_recipesofweek_recepie1_idx` (`recepie_name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `godb`;

DELIMITER $$
USE `godb`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `godb`.`recipesofweek_AFTER_INSERT`
AFTER INSERT ON `godb`.`recipesofweek`
FOR EACH ROW
BEGIN
    DECLARE ingredientName varchar(60);
    INSERT INTO `godb`.`list` (`ingredient`) SELECT ingredients_name FROM godb.recepie_has_ingredients WHERE recepie_name IN (New.recepie_name);
END$$

USE `godb`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `godb`.`recipesofweek_AFTER_UPDATE`
AFTER UPDATE ON `godb`.`recipesofweek`
FOR EACH ROW
BEGIN
DELETE FROM `godb`.`list` WHERE ingredient IN (SELECT ingredients_name FROM godb.recepie_has_ingredients WHERE recepie_name IN (Old.recepie_name));
INSERT INTO `godb`.`list` (`ingredient`) SELECT ingredients_name FROM godb.recepie_has_ingredients WHERE recepie_name IN (New.recepie_name);
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
