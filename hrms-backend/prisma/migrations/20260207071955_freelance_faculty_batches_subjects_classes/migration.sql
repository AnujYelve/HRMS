/*
  Warnings:

  - You are about to drop the column `batch` on the `freelance_faculty_day_entries` table. All the data in the column will be lost.
  - You are about to drop the column `classesCount` on the `freelance_faculty_day_entries` table. All the data in the column will be lost.
  - You are about to drop the column `subjects` on the `freelance_faculty_day_entries` table. All the data in the column will be lost.
  - You are about to drop the column `topic` on the `freelance_faculty_day_entries` table. All the data in the column will be lost.
  - You are about to drop the column `totalHours` on the `freelance_faculty_day_entries` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[email]` on the table `freelance_faculties` will be added. If there are existing duplicate values, this will fail.
  - Made the column `freelanceFacultyManagerId` on table `freelance_faculties` required. This step will fail if there are existing NULL values in that column.

*/
-- DropForeignKey
ALTER TABLE "freelance_faculties" DROP CONSTRAINT "freelance_faculties_freelanceFacultyManagerId_fkey";

-- DropForeignKey
ALTER TABLE "freelance_faculty_day_entries" DROP CONSTRAINT "freelance_faculty_day_entries_facultyId_fkey";

-- AlterTable
ALTER TABLE "freelance_faculties" ADD COLUMN     "email" TEXT,
ADD COLUMN     "joiningDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "phone" TEXT,
ALTER COLUMN "freelanceFacultyManagerId" SET NOT NULL;

-- AlterTable
ALTER TABLE "freelance_faculty_day_entries" DROP COLUMN "batch",
DROP COLUMN "classesCount",
DROP COLUMN "subjects",
DROP COLUMN "topic",
DROP COLUMN "totalHours",
ADD COLUMN     "createdBy" TEXT,
ADD COLUMN     "isPresent" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "remarks" TEXT,
ADD COLUMN     "totalClasses" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "totalDuration" INTEGER NOT NULL DEFAULT 0;

-- CreateTable
CREATE TABLE "batches" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT,
    "description" TEXT,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "batches_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subjects" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "subjects_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "classes" (
    "id" TEXT NOT NULL,
    "dayEntryId" TEXT NOT NULL,
    "batchId" TEXT NOT NULL,
    "subjectId" TEXT NOT NULL,
    "topic" TEXT NOT NULL,
    "startTime" TIME NOT NULL,
    "endTime" TIME NOT NULL,
    "duration" INTEGER NOT NULL,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "classes_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "batches_code_key" ON "batches"("code");

-- CreateIndex
CREATE UNIQUE INDEX "subjects_code_key" ON "subjects"("code");

-- CreateIndex
CREATE INDEX "classes_dayEntryId_idx" ON "classes"("dayEntryId");

-- CreateIndex
CREATE INDEX "classes_batchId_idx" ON "classes"("batchId");

-- CreateIndex
CREATE INDEX "classes_subjectId_idx" ON "classes"("subjectId");

-- CreateIndex
CREATE UNIQUE INDEX "freelance_faculties_email_key" ON "freelance_faculties"("email");

-- CreateIndex
CREATE INDEX "freelance_faculty_day_entries_date_idx" ON "freelance_faculty_day_entries"("date");

-- AddForeignKey
ALTER TABLE "freelance_faculties" ADD CONSTRAINT "freelance_faculties_freelanceFacultyManagerId_fkey" FOREIGN KEY ("freelanceFacultyManagerId") REFERENCES "freelance_faculty_managers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "freelance_faculty_day_entries" ADD CONSTRAINT "freelance_faculty_day_entries_facultyId_fkey" FOREIGN KEY ("facultyId") REFERENCES "freelance_faculties"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "classes" ADD CONSTRAINT "classes_dayEntryId_fkey" FOREIGN KEY ("dayEntryId") REFERENCES "freelance_faculty_day_entries"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "classes" ADD CONSTRAINT "classes_batchId_fkey" FOREIGN KEY ("batchId") REFERENCES "batches"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "classes" ADD CONSTRAINT "classes_subjectId_fkey" FOREIGN KEY ("subjectId") REFERENCES "subjects"("id") ON DELETE CASCADE ON UPDATE CASCADE;
